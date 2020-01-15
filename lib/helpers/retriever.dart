import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class Retriever {
  static String lawTextString;
  static Map<String, String> lawContents = {};

  static Future<Map<String, String>> retrieveLawText({String url}) async {
    await _getLawTextString(url);
    _parseAllArticlesExceptLast();
    _parseLastArticle();
    return lawContents;
  }

  static retrieveModificationRelations({String url}) async {
    // Example law: number 17319, ID 16078 -- DELETE LATER
    // Example law: number 11723, ID 42755 -- DELETE LATER

    // get lawId
    RegExp regExpForLawId = RegExp(r'/(\d*)/(norma|texact)');
    String lawId = regExpForLawId.firstMatch(url).group(1);

    // get <tr> elements
    // String modifiesUrl =
    //     "http://servicios.infoleg.gob.ar/infolegInternet/verVinculos.do?modo=1&id=$lawId";
    String isModifiedByUrl =
        "http://servicios.infoleg.gob.ar/infolegInternet/verVinculos.do?modo=2&id=$lawId";
    print(isModifiedByUrl);
    http.Response response = await http.get(isModifiedByUrl);
    Document document = parse(response.body);
    List<Element> tableRows = document.body.getElementsByTagName("tr");

    // clean <tr> elements
    Map<int, Element> cleanTableRowsObject = {};
    tableRows.asMap().entries.forEach((entry) {
      if (entry.key != 0 && entry.key % 2 != 0) {
        // filter out useless <td>, having indices: 0, 2, 4, etc.
        cleanTableRowsObject[entry.key] = entry.value;
      }
    });

    // for each <tr> element, get text of <td> elements (three <td> per <tr>)
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
        String cleanCellText = cell.text
            .replaceAll("\t", "")
            .replaceAll("\n", " ")
            .replaceAll(RegExp(r"\s\s+"), " ")
            .trim();

        // populate each cells in row
        if (i == 0) {
          singleRow["norm"] = cleanCellText;
        } else if (i == 1) {
          singleRow["publicationDate"] = cleanCellText;
        } else if (i == 2) {
          singleRow["description"] = cleanCellText;
        }
      }

      // add single row to all rows by index
      allRows[idx] = singleRow;
    });

    print(allRows);
  }

  static Future<void> _getLawTextString(String url) async {
    http.Response response = await http.get(url);
    Document document = parse(response.body);
    lawTextString = document.body.text.replaceAll("\n", " ");
  }

  static _parseAllArticlesExceptLast() {
    RegExp regExpForEachArticleExceptLast =
        RegExp(r"(Art(.|ículo)? (\d*).? -)(.+?)(?=  Art. )");
    Iterable<RegExpMatch> articleMatches =
        regExpForEachArticleExceptLast.allMatches(lawTextString);

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

    RegExp regExpForLastArticle = RegExp(r"(Art(.|ículo)? (\d*).? -)(.*)");
    RegExpMatch lastArticleMatch =
        regExpForLastArticle.firstMatch(lastArticleAndTrailingExtras);

    String lastArticleNumber = lastArticleMatch.group(3);

    String dirtyLastArticleText = lastArticleMatch.group(4);
    String lastArticleText =
        RegExp(r"(.*\.)(\s\s+.*$)").firstMatch(dirtyLastArticleText).group(1);

    lawContents[lastArticleNumber] = lastArticleText;
  }
}
