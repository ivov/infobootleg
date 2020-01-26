import 'package:flutter/material.dart';
import 'package:infobootleg/widgets/article_card.dart';

class ArticleCardWithCommentBox extends StatelessWidget {
  ArticleCardWithCommentBox({
    @required this.lawNumber,
    @required this.articleNumber,
    @required this.favoriteText,
  });

  final String lawNumber;
  final String articleNumber;
  final RichText favoriteText;

  @override
  Widget build(BuildContext context) {
    return ArticleCard(
      articleNumber: articleNumber,
      forFavoritesScreen: true,
      favoriteText: favoriteText,
    );
  }
}
