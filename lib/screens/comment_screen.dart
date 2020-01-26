import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:infobootleg/widgets/article_card_with_comment_box.dart';
import 'package:infobootleg/widgets/short_title_card.dart';
import 'package:infobootleg/models/search_state_model.dart';

class CommentScreen extends StatelessWidget {
  CommentScreen(this.searchState);

  final SearchStateModel searchState;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Theme.of(context).canvasColor,
        body: Column(
          children: [
            ShortTitleCard(title: "Comentar artículo"),
            ArticleCardWithCommentBox(
              articleNumber: searchState.articleToComment["articleNumber"],
              favoriteText: searchState.articleToComment["favoriteText"],
            )
          ],
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
}
