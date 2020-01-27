import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  ArticleCard({
    this.cardColor,
    this.articleNumber,
    this.articleText,
    this.isFavorite,
    this.favoriteText,
    this.comment,
  });

  final Color cardColor;
  final String articleNumber;
  final String articleText;
  final bool isFavorite;
  final RichText favoriteText;
  final String comment;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      color: cardColor,
      child: Row(
        children: [
          _buildLeftSideOfCard(),
          _buildRightSideOfCard(context),
        ],
      ),
    );
  }

  _buildLeftSideOfCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        "Art.\n" + articleNumber,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  _buildRightSideOfCard(BuildContext context) {
    // The article text on the right side can be non-favorite (article text as String, no addition) or favorite (article text as RichText, with addition of bolded em dash and law number at the end). Favorites may also include comments.

    if (isFavorite == true) {
      // favorite with comment
      if (comment != null) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                favoriteText, // ← RichText with addition
                _buildCommentBox(context),
              ],
            ),
          ),
        );
      }

      // favorite without comment
      return Expanded(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: favoriteText, // ← RichText with addition
        ),
      );
    }

    // non-favorite
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          articleText, // ← String
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }

  _buildCommentBox(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, right: 50.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            child: Card(
              elevation: 5.0,
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  comment,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
