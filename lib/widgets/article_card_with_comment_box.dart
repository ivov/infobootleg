import 'package:flutter/material.dart';
import 'package:infobootleg/widgets/article_card.dart';

class ArticleCardWithCommentBox extends StatelessWidget {
  ArticleCardWithCommentBox({
    @required this.articleNumber,
    @required this.favoriteText,
  });

  final String articleNumber;
  final RichText favoriteText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 7.5,
        horizontal: 10.0,
      ),
      child: ArticleCard(
        cardColor: Colors.white,
        articleNumber: articleNumber,
        isFavorite: true,
        favoriteText: favoriteText,
      ),
    );
  }
}
