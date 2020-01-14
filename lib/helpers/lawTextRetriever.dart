import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

String url =
    "http://servicios.infoleg.gob.ar/infolegInternet/anexos/190000-194999/194196/norma.htm";

class LawTextRetriever {
  String result;

  Future<void> retrieveLawText() async {
    http.Response response = await http.get(url);
    Document document = parse(response.body);
    result = document.body.text.replaceAll("\n", " ");

    Map<String, String> lawContents = {};

    // TODO: Last article not being matched because last article has no "  Art. " after it.
    RegExp regExpForEachArticle =
        RegExp(r"(Art(.|ículo)? \d*.? -)(.+?)(?=  Art. )");
    Iterable<RegExpMatch> articleMatches =
        regExpForEachArticle.allMatches(result);

    // String reversedResult = result.split('').reversed.join();
    // RegExp regExpForLastArticle = RegExp(r"(.*)(- .? \d*)");
    // RegExpMatch lastArticleMatch =
    //     regExpForLastArticle.firstMatch(reversedResult);
    // String dereversedResult =
    //     lastArticleMatch.group(1).split('').reversed.join();

    // print(dereversedResult);

    // group1: (Art(.|ículo)? \d*.? -) → dirtyArticleNumber
    // group2: (.|ículo) → inner group for parsing only
    // group3: (.+?) → articleText

    articleMatches.forEach((articleMatch) {
      String dirtyArticleNumber = articleMatch.group(1);
      RegExp regExpForNumberOnly = RegExp(r"\d+");
      RegExpMatch numberMatch =
          regExpForNumberOnly.firstMatch(dirtyArticleNumber);
      String cleanArticleNumber = numberMatch.group(0);

      String articleText = articleMatch.group(3).trim();
      lawContents[cleanArticleNumber] = articleText;
    });

    // debugPrint(lawContents.length.toString());
  }
}
