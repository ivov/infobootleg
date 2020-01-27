import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:infobootleg/models/favorite_model.dart';
import 'package:infobootleg/services/database_service.dart';
import 'package:infobootleg/widgets/basic_card.dart';
import 'package:infobootleg/widgets/article_card_with_comment_box.dart';
import 'package:infobootleg/widgets/short_title_card.dart';
import 'package:infobootleg/models/search_state_model.dart';

class CommentScreen extends StatelessWidget {
  // Stateful become of TextEditingController.
  CommentScreen(this.searchState, this.dbService);

  final SearchStateModel searchState;
  final DatabaseService dbService;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: _buildAppBar(),
        backgroundColor: Theme.of(context).canvasColor,
        body: Builder(
          // gets context under the Scaffold, for Snackbar down below
          builder: (context) => SingleChildScrollView(
            // prevents keyboard from blocking text field
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
    return BasicCard(
      cardContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: TextField(
              onSubmitted: (userInput) => _onSubmitted(context, userInput),
              textInputAction: TextInputAction.done,
              controller: _textEditingController,
              style: TextStyle(
                  fontSize: 18.0, color: Theme.of(context).primaryColor),
              maxLines: 8,
              decoration: InputDecoration.collapsed(
                hintText: "Ingresar comentario...",
              ),
            ),
          )
        ],
      ),
    );
  }

  _onSubmitted(BuildContext context, String userInput) async {
    final Favorite favorite = Favorite(
      lawNumber: searchState.articleToComment["lawNumber"],
      articleNumber: searchState.articleToComment["articleNumber"],
      articleText: searchState.articleToComment["articleText"],
    );

    await dbService.addCommentToFavorite(favorite, userInput);
    _showSnackBar(favorite, context);
    // sleep(Duration(seconds: 2));
  }

  _showSnackBar(
    Favorite favorite,
    BuildContext context,
  ) {
    String snackBarText =
        "Comentario agregado al art. ${favorite.articleNumber}";

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
      _textEditingController.clear();
      searchState.transitionHorizontallyTo(Screen.favorites);
    });
  }
}
