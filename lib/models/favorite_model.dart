class Favorite {
  Favorite({
    lawNumber,
    this.articleNumber,
    this.articleText,
  }) : dotlessLawNumber = lawNumber.replaceAll(".", "");

  // The dotless fieldname enables `FieldValue.delete()` at `deleteFavorite` method in `DatabaseService`.

  String dotlessLawNumber;
  final String articleNumber;
  final String articleText;

  get lawAndArticle => dotlessLawNumber + "&" + articleNumber;

  Map<String, dynamic> toMap() {
    return {
      lawAndArticle: {"articleText": articleText},
    };
  }
}
