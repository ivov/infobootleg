import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:infobootleg/screens/law_summary_screen.dart';

class Retriever {
  static String lawTextString;
  static Map<String, String> lawContents = {};

  static Future<Map<String, String>> retrieveLawText({String url}) async {
    await _getLawTextString(url);
    _parseAllArticlesExceptLast();
    // _parseLastArticle();
    return lawContents;
  }

  static Future<void> _getLawTextString(String url) async {
    http.Response response = await http.get(url);
    Document document = parse(response.body);
    lawTextString = document.body.text.replaceAll("\n", " ");
  }

  static _selectRelevantRegex() {
    RegExp regexpFor20305 =
        RegExp(r"(Art(\.|ículo)?\s(\d*)º?.?\s-\s)(.+?)(?=\s+Art.\s)");
    RegExp regexpFor11723 =
        RegExp(r"(Art(\.|ículo)?\s(\d*)°?.?\s\s)(.+?)(?=Art.\s)");

    if (lawTextString.contains(regexpFor20305)) {
      return regexpFor20305;
    } else if (lawTextString.contains(regexpFor11723)) {
      return regexpFor11723;
    }
  }

  static _parseAllArticlesExceptLast() {
    RegExp relevantRegex = _selectRelevantRegex();

    Iterable<RegExpMatch> articleMatches =
        relevantRegex.allMatches(lawTextString);

    articleMatches.forEach((articleMatch) {
      String articleNumber = articleMatch.group(3);
      String articleText = articleMatch.group(4).trim();
      lawContents[articleNumber] = articleText;
    });
  }

  static void _parseLastArticle() {
    RegExp regExpForLastArticleAndTrailingExtras = RegExp(r"(?!.* Art)(.*)$");
    String lastArticleAndTrailingExtras = regExpForLastArticleAndTrailingExtras
        .firstMatch(lawTextString)
        .group(0);

    RegExp regExpForLastArticle = RegExp(r"(Art(.|ículo)?\s(\d*).?\s-)(.*)");
    RegExpMatch lastArticleMatch =
        regExpForLastArticle.firstMatch(lastArticleAndTrailingExtras);

    String lastArticleNumber = lastArticleMatch.group(3);

    String dirtyLastArticleText = lastArticleMatch.group(4);
    String lastArticleText =
        RegExp(r"(.*\.)(\s\s+.*$)").firstMatch(dirtyLastArticleText).group(1);

    lawContents[lastArticleNumber] = lastArticleText;
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
  /// The dunder "\_\_DIVIDER__" string is inserted to allow for proper division of the cell into two lines.
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
