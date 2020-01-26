import 'package:flutter/material.dart';
import 'package:infobootleg/widgets/article_card.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:infobootleg/models/favorite_model.dart';
import 'package:infobootleg/widgets/confirmation_prompt.dart';

class ArticleCardWithCornerIcons extends StatefulWidget {
  // stateful because of cardColor
  ArticleCardWithCornerIcons({
    @required this.position,
    @required this.lawNumber,
    @required this.articleNumber,
    @required this.articleText,
    @required this.isStarred,
    @required this.onArticleSelected,
    @required this.onSave,
    @required this.onDelete,
    @required this.onSaveOrDeleteCompleted,
    this.forFavoritesScreen = false,
    this.favoriteText,
    this.onCommentPressed,
  });

  final int position;
  final String lawNumber;
  final String articleNumber;
  final String articleText;
  final bool isStarred;
  final void Function(int, {int milliseconds}) onArticleSelected;
  final Function onSave;
  final Function onDelete;
  final Function onSaveOrDeleteCompleted;
  final bool forFavoritesScreen;
  final RichText favoriteText;
  final Function onCommentPressed;

  @override
  _ArticleCardWithCornerIconsState createState() =>
      _ArticleCardWithCornerIconsState();
}

class _ArticleCardWithCornerIconsState
    extends State<ArticleCardWithCornerIcons> {
  Color cardColor = Colors.white;

  void _confirmAction(BuildContext context) async {
    setState(() => cardColor = Colors.lightBlueAccent);

    widget.onArticleSelected(widget.position, milliseconds: 200);

    if (!widget.isStarred) {
      _confirmSave(context);
    } else if (widget.isStarred) {
      _confirmDelete(context);
    }
  }

  void _confirmSave(BuildContext context) async {
    bool answer = await ConfirmationPrompt(
      question: "¿Guardar el art. ${widget.articleNumber}\n en mis favoritos?",
    ).show(context);

    if (answer == true) {
      Favorite favorite = Favorite(
        lawNumber: widget.lawNumber,
        articleNumber: widget.articleNumber,
        articleText: widget.articleText,
      );
      await widget.onSave(favorite);
      widget.onSaveOrDeleteCompleted(favorite, context, onSave: true);
    }
    setState(() => cardColor = Colors.white);
  }

  void _confirmDelete(BuildContext context) async {
    bool answer = await ConfirmationPrompt(
      question: "¿Eliminar el art. ${widget.articleNumber}\n de mis favoritos?",
    ).show(context);

    if (answer == true) {
      Favorite favorite = Favorite(
        lawNumber: widget.lawNumber,
        articleNumber: widget.articleNumber,
        articleText: widget.articleText,
      );
      await widget.onDelete(favorite);
      widget.onSaveOrDeleteCompleted(favorite, context, onDelete: true);
    }
    setState(() => cardColor = Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 7.5,
        horizontal: 10.0,
      ),
      child: Stack(
        children: [
          GestureDetector(
            onLongPress: () => _confirmAction(context),
            child: ArticleCard(
              cardColor: cardColor,
              articleNumber: widget.articleNumber,
              articleText: widget.articleText,
              isFavorite: widget.forFavoritesScreen,
              favoriteText: widget.favoriteText,
            ),
          ),
          _buildStarIcon(),
          _buildCommentIcon()
        ],
      ),
    );
  }

  _buildStarIcon() {
    return Visibility(
      visible: widget.isStarred,
      child: Positioned(
        top: 5.0,
        left: 5.0,
        child: Icon(MdiIcons.star, color: Colors.lightBlueAccent),
      ),
    );
  }

  _buildCommentIcon() {
    // at LawSearchScreen, no comment icon
    if (widget.forFavoritesScreen == false) return Container();

    return Positioned(
      bottom: 10.0,
      right: 10.0,
      child: InkWell(
        onTap: widget.onCommentPressed,
        child: Icon(
          MdiIcons.pen,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
