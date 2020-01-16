import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:infobootleg/screens/law_summary_screen.dart';

/// Every law has a different format, so these are various templates for parsing laws.
/// Each template has two regexes: for most articles (initial) and for final article (final).
/// In both regexes, match group 3 is article number and match group 4 is article text.
Map<String, Map<String, RegExp>> lawRegexes = {
  "law20305": {
    "initial": RegExp(r"(Art(\.|ículo)?\s(\d*)º?.?\s-\s)(.+?)(?=\s+Art.\s)"),
    "final":
        RegExp(r"(?!.* Art)(Art(\.|ículo)?\s(\d*)º?.?\s-\s)(.*\.)(?=\s{3})")
  },
  "law11723": {
    "initial": RegExp(r"(Art(\.|ículo)?\s(\d*)°?.?\s\s)(.+?)(?=Art.\s)"),
    "final": RegExp(r"(?!.*\s{2}Art)(Art(.|ículo)?\s(\d*).?\s)(.*?\.)")
  },
};

class Retriever {
  static String lawTextString;
  static Map<String, String> lawContents = {};
  static String lawPattern;

  static Future<Map<String, String>> retrieveLawText({String url}) async {
    await _getLawTextString(url);
    _selectLawPattern();
    _parseMostArticles();
    _parseFinalArticle();
    return lawContents;
  }

  static Future<void> _getLawTextString(String url) async {
    http.Response response = await http.get(url);
    Document document = parse(response.body);
    lawTextString = document.body.text.replaceAll("\n", " ");
  }

  static void _selectLawPattern() {
    if (lawTextString.contains(lawRegexes["law20305"]["initial"])) {
      lawPattern = "law20305";
    } else if (lawTextString.contains(lawRegexes["law11723"]["initial"])) {
      lawPattern = "law11723";
    }
  }

  static _parseMostArticles() {
    // i.e., parse all articles EXCEPT final article, using initial regex
    RegExp initialRegex = lawRegexes[lawPattern]["initial"];

    Iterable<RegExpMatch> articleMatches =
        initialRegex.allMatches(lawTextString);

    articleMatches.forEach((articleMatch) {
      String articleNumber = articleMatch.group(3);
      String articleText = articleMatch.group(4);

      lawContents[articleNumber] = articleText;
    });
  }

  static void _parseFinalArticle() {
    RegExp finalRegex = lawRegexes[lawPattern]["final"];
    RegExpMatch finalArticleMatch = finalRegex.firstMatch(lawTextString);

    String finalArticleNumber = finalArticleMatch.group(3);
    String finalArticleText = finalArticleMatch.group(4);

    lawContents[finalArticleNumber] = finalArticleText;
  }

  /// Accepts the URL for the full text of a law and the selected type of modification (modifies or is modified by), retrieves the selected modification relations table of the law at InfoLeg, and returns an object consisting of rows containing object containing the cells of the row.
  /// Example return object:
  /// ```
  /// { 1:
  ///   {
  ///     "firstCell": "DISPOSICIÓN 1120/91__DIVIDER__PODER EJECUTIVO NACIONAL",
  ///     "secondCell": "11-dec-1991",
  ///     "thirdCell": "FONDO NACIONAL__DIVIDER__NORMAS REGLAMENTARIAS"
  ///   },
  ///   2: { ... }
  /// }
  /// ```
  /// The "\_\_DIVIDER__" string is inserted to allow for proper division of the cell into two lines later on.
  static Future<Map<int, Map<String, String>>> retrieveModificationRelations(
      {String fullTextUrl, ModificationType modificationType}) async {
    // Example law: number 17319, ID 16078 -- DELETE LATER
    // Example law: number 11723, ID 42755 -- DELETE LATER

    // 1. build relationsUrl
    RegExp regExpForLawId = RegExp(r'/(\d*)/(norma|texact)');
    String lawId = regExpForLawId.firstMatch(fullTextUrl).group(1);

    String relationsUrl =
        "http://servicios.infoleg.gob.ar/infolegInternet/verVinculos.do?modo=";
    if (modificationType == ModificationType.modifies) {
      relationsUrl += "1&id=$lawId";
    } else if (modificationType == ModificationType.isModifiedBy) {
      relationsUrl += "2&id=$lawId";
    }

    // 2. get table rows
    http.Response response = await http.get(relationsUrl);
    Document document = parse(response.body);
    List<Element> tableRows = document.body.getElementsByTagName("tr");

    // 3. filter out rows containing useless cells (indices 0, 2, 4, etc.)
    Map<int, Element> cleanTableRowsObject = {};
    tableRows.asMap().entries.forEach((entry) {
      if (entry.key != 0 && entry.key % 2 != 0) {
        cleanTableRowsObject[entry.key] = entry.value;
      }
    });

    // build object consisting of row number (key) and
    // object containing three cells (value)
    List<Element> cleanTableRows = cleanTableRowsObject.values.toList();

    Map<int, Map<String, String>> allRows = {};

    // iterate over each row, with index for identification
    cleanTableRows.asMap().entries.forEach((entry) {
      int idx = entry.key;

      List<Element> threeCells = entry.value.getElementsByTagName("td");

      Map<String, String> singleRow = {};

      // iterate over each cell in row
      for (int i = 0; i < threeCells.length; i++) {
        Element cell = threeCells[i];

        // at first cell of row, divide provision and originating body
        if (i == 0) {
          cell.text = _addDividerInCellContents(cell, firstSegmentTag: "a");
        }

        if (i == 1) {
          cell.text = cell.text.trim();
        }

        // at third cell of row, divide topic and description
        if (i == 2) {
          cell.text = _addDividerInCellContents(cell, firstSegmentTag: "b");
        }

        // populate each cell in row, use index for labels
        if (i == 0) {
          singleRow["firstCell"] = cell.text; // provision and originatingBody
        } else if (i == 1) {
          singleRow["secondCell"] = cell.text; // publication date
        } else if (i == 2) {
          singleRow["thirdCell"] = cell.text; // topic and description
        }
      }

      // add single row to all rows by index
      allRows[idx] = singleRow;
    });

    return allRows;
  }

  static String _addDividerInCellContents(Element cell,
      {String firstSegmentTag}) {
    // first segment
    String firstSegment = cell
        .getElementsByTagName(firstSegmentTag)[0]
        .text
        .replaceAll(RegExp(r"\s\s+"), " ")
        .trim();

    // second segment
    String cellInnerHtml = cell.innerHtml.toString();
    RegExp regexpForSecondSegment;
    if (firstSegmentTag == "a") {
      regexpForSecondSegment = RegExp(r"</a>([\S\s]*?)<br/?>");
    } else if (firstSegmentTag == "b") {
      regexpForSecondSegment = RegExp(r"<br/?>([\S\s]*)");
    }
    String secondSegment = regexpForSecondSegment
        .firstMatch(cellInnerHtml)
        .group(1)
        .replaceAll(RegExp(r"\s\s+"), " ")
        .trim();

    return firstSegment + "__DIVIDER__" + secondSegment;
  }
}
