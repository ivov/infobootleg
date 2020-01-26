import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  ArticleCard({
    this.cardColor,
    this.articleNumber,
    this.articleText,
    this.isFavorite,
    this.favoriteText,
  });

  final Color cardColor;
  final String articleNumber;
  final String articleText;
  final bool isFavorite;
  final RichText favoriteText;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      color: cardColor,
      child: Row(
        children: [
          _buildLeftSideOfCard(),
          _buildRightSideOfCard(),
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

  _buildRightSideOfCard() {
    if (isFavorite == true) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: favoriteText,
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          articleText,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
