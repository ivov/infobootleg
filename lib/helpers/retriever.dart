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
