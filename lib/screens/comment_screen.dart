import 'package:flutter/material.dart';
import 'package:infobootleg/widgets/basic_card.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:infobootleg/widgets/article_card_with_comment_box.dart';
import 'package:infobootleg/widgets/short_title_card.dart';
import 'package:infobootleg/models/search_state_model.dart';

class CommentScreen extends StatelessWidget {
  // Stateful become of TextEditingController.
  CommentScreen(this.searchState);

  final SearchStateModel searchState;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: _buildAppBar(),
        backgroundColor: Theme.of(context).canvasColor,
        body: SingleChildScrollView(
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
              onSubmitted: (userInput) => _onSubmitted(userInput),
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

  _onSubmitted(String userInput) {
    print(userInput);
    // TODO: _onSubmitted
    // - Save userInput to Firestore.
    // - Show snackbar confirming operation.
    // - Wait two seconds and return to FavoritesScreen.
  }
}
