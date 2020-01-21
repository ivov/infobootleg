import 'package:flutter/material.dart';
import 'package:infobootleg/services/database_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:infobootleg/models/favorite_model.dart';
import 'package:infobootleg/widgets/confirmation_prompt.dart';

class ArticleCard extends StatefulWidget {
  ArticleCard({
    @required this.position,
    @required this.lawNumber,
    @required this.articleNumber,
    @required this.articleText,
    @required this.isStarred,
    @required this.onArticleSelected,
    @required this.onSaveOrDelete,
    @required this.dbService,
    this.forFavoritesScreen = false,
    this.favoriteText,
  });

  final int position;
  final DatabaseService dbService;
  final String lawNumber;
  final String articleNumber;
  final String articleText;
  final bool isStarred;
  final void Function(int, {int milliseconds}) onArticleSelected;
  final Function onSaveOrDelete;

  final bool forFavoritesScreen;
  final RichText favoriteText;

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
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
      await widget.dbService.saveFavorite(favorite);
      widget.onSaveOrDelete(favorite, context, onSave: true);
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
      await widget.dbService.deleteFavorite(favorite);
      widget.onSaveOrDelete(favorite, context, onDelete: true);
    }
    setState(() => cardColor = Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onLongPress: () => _confirmAction(context),
          child: Card(
            elevation: 5.0,
            color: cardColor,
            child: Row(
              children: [
                _buildLeftSideOfCard(),
                _buildRightSideOfCard(),
              ],
            ),
          ),
        ),
        _buildStarIcon()
      ],
    );
  }

  _buildLeftSideOfCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        "Art.\n" + widget.articleNumber,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  _buildRightSideOfCard() {
    if (widget.forFavoritesScreen == true) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: widget.favoriteText,
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          widget.articleText,
          style: TextStyle(fontSize: 18.0),
        ),
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
}
