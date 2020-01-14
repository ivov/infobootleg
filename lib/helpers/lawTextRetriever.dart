import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class LawTextRetriever {
  LawTextRetriever({@required this.url});

  String url;
  String lawTextString;
  Map<String, String> lawContents = {};

  retrieveLawText() async {
    await _getLawTextString();
    _parseAllArticlesExceptLast();
    _parseLastArticle();
  }

  Future<void> _getLawTextString() async {
    http.Response response = await http.get(url);
    Document document = parse(response.body);
    lawTextString = document.body.text.replaceAll("\n", " ");
  }

  void _parseAllArticlesExceptLast() {
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

  void _parseLastArticle() {
    RegExp regExpForLastArticleAndTrailingExtras = RegExp(r"(?!.* Art)(.*)$");
    String lastArticleAndTrailingExtras = regExpForLastArticleAndTrailingExtras
        .firstMatch(lawTextString)
        .group(0);

    RegExp regExpForLastArticle = RegExp(r"(Art(.|ículo)? (\d*).? -)(.*)");
    RegExpMatch lastArticleMatch =
        regExpForLastArticle.firstMatch(lastArticleAndTrailingExtras);

    String lastArticleNumber = lastArticleMatch.group(3);

    String dityLastArticleText = lastArticleMatch.group(4);
    String lastArticleText =
        RegExp(r"(.*\.)(\s\s+.*$)").firstMatch(dityLastArticleText).group(1);

    lawContents[lastArticleNumber] = lastArticleText;
  }
}
