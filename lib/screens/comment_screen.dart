import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:infobootleg/models/search_state_model.dart';
import 'package:infobootleg/models/favorite_model.dart';
import 'package:infobootleg/services/firestore_database_service.dart';
import 'package:infobootleg/widgets/basic_card.dart';
import 'package:infobootleg/widgets/article_card_with_comment_box.dart';
import 'package:infobootleg/widgets/short_title_card.dart';

class CommentScreen extends StatelessWidget {
  CommentScreen(this.searchState, this.dbService)
      : favorite = Favorite(
          lawNumber: searchState.articleToComment["lawNumber"],
          articleNumber: searchState.articleToComment["articleNumber"],
          articleText: searchState.articleToComment["articleText"],
        );

  final SearchStateModel searchState;
  final FirestoreDatabaseService dbService;
  final Favorite favorite;
  final TextEditingController _textEditingController = TextEditingController();

  Future<String> _getCommentForArticle() async {
    String lawAndArticle = searchState.articleToComment["lawNumber"] +
        "&" +
        searchState.articleToComment["articleNumber"];

    DocumentSnapshot snapshot = await dbService.readAllFavoritesOfUser();
    Map<String, dynamic> allFavoritesOfUser = snapshot.data;

    return allFavoritesOfUser[lawAndArticle]["comment"];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: _buildAppBar(),
        backgroundColor: Theme.of(context).canvasColor,
        body: Builder(
          // Builder gets context under the Scaffold, for Snackbar down below.
          builder: (context) => SingleChildScrollView(
            // SingleChildScrollView prevents keyboard from blocking text field.
            child: Column(
              children: [
                ShortTitleCard(title: "Comentar artículo"),
                ArticleCardWithCommentBox(
                  articleNumber: searchState.articleToComment["articleNumber"],
                  favoriteText: searchState.articleToComment["favoriteText"],
                ),
                _buildTextField(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: GestureDetector(
        child: Text("Volver a favoritos"),
        onTap: () => searchState.transitionHorizontallyTo(Screen.favorites),
      ),
      leading: IconButton(
        icon: Icon(MdiIcons.arrowLeft),
        onPressed: () => searchState.transitionHorizontallyTo(Screen.favorites),
      ),
    );
  }

  _buildTextField(BuildContext context) {
    return FutureBuilder(
      future: _getCommentForArticle(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // populate TextField if comment exists
        _textEditingController.text = snapshot.data ?? "";
        bool visible = snapshot.data != null;
        return Stack(
          children: [
            BasicCard(
              cardContent: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: TextField(
                      onSubmitted: (userInput) =>
                          _onSubmitted(context, userInput),
                      textInputAction: TextInputAction.done,
                      controller: _textEditingController,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColor),
                      maxLines: 6,
                      decoration: InputDecoration.collapsed(
                        hintText: "Ingresar comentario...",
                      ),
                    ),
                  )
                ],
              ),
            ),
            _buildCrossIcon(context, visible)
          ],
        );
      },
    );
  }

  _buildCrossIcon(BuildContext context, bool visible) {
    return Visibility(
      visible: visible,
      child: Positioned(
        top: 10.0,
        right: 10.0,
        child: InkWell(
          onTap: () => _onCrossIconPressed(context),
          child: Icon(
            MdiIcons.windowClose,
            size: 28.0,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  _onCrossIconPressed(BuildContext context) async {
    _textEditingController.clear();
    await dbService.deleteCommentFromFavorite(favorite);
    _showSnackBar(favorite, context, onDelete: true);
  }

  _onSubmitted(BuildContext context, String userInput) async {
    await dbService.addCommentToFavorite(favorite, userInput);
    _showSnackBar(favorite, context, onSave: true);
  }

  _showSnackBar(Favorite favorite, BuildContext context,
      {onSave = false, onDelete = false}) {
    String snackBarText = "Comentario ";
    if (onSave) {
      snackBarText += 'agregado al ';
    } else if (onDelete) {
      snackBarText += 'eliminado del ';
    }
    snackBarText += "art. ${favorite.articleNumber}";

    final snackBar = SnackBar(
      duration: Duration(seconds: 1),
      content: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Icon(MdiIcons.star),
          ),
          Text(
            snackBarText,
            style: TextStyle(fontSize: 18.0),
          )
        ],
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar).closed.then((reason) {
      searchState.transitionHorizontallyTo(Screen.favorites);
    });
  }
}
