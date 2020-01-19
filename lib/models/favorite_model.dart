class Favorite {
  Favorite({
    this.lawNumber,
    this.articleNumber,
    this.articleText,
  });

  final String lawNumber;
  final String articleNumber;
  final String articleText;

  get lawAndArticle => lawNumber + "&" + articleNumber;

  // Map<String, dynamic> toMap() {
  //   return {
  //     "lawAndArticle": lawAndArticle,
  //     "articleText": articleText,
  //   };
  // }

  Map<String, dynamic> toMap() {
    return {
      lawAndArticle: {"articleText": articleText},
    };
  }
}
