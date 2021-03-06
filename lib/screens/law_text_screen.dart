import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:infobootleg/models/favorite_model.dart';
import 'package:infobootleg/models/search_state_model.dart';
import 'package:infobootleg/services/firestore_database_service.dart';
import 'package:infobootleg/widgets/article_card_with_corner_icons.dart';
import 'package:infobootleg/widgets/law_title_card.dart';
import 'package:infobootleg/widgets/table_of_contents.dart';

class LawTextScreen extends StatelessWidget {
  LawTextScreen(this.searchState, this.dbService);

  final SearchStateModel searchState;
  final FirestoreDatabaseService dbService;
  final ItemScrollController _scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: TableOfContents(
          onListItemSelected: scrollToListItem,
          drawerTitle: "Ley " + searchState.activeLaw.number,
          drawerSubtitle: "Índice de artículos",
          drawerContents: searchState.lawContents,
        ),
        appBar: _buildAppBar(),
        backgroundColor: Theme.of(context).canvasColor,
        body: _buildScrollablePositionedList(context),
      ),
    );
  }

  void scrollToListItem(int index, {int milliseconds = 500}) {
    _scrollController.scrollTo(
      index: index + 1, // add 1 to account for LawTitleCard at zeroth index
      duration: Duration(milliseconds: milliseconds),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: GestureDetector(
        child: Text("Volver al resumen"),
        onTap: () => searchState.transitionVerticallyTo(Screen.summary),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_upward),
        onPressed: () => searchState.transitionVerticallyTo(Screen.summary),
      ),
    );
  }

  _buildScrollablePositionedList(BuildContext context) {
    return StreamBuilder(
      stream: dbService.streamAllFavoritesOfUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        Map<String, dynamic> userFavorites = snapshot.data.data;
        return ScrollablePositionedList.builder(
          itemScrollController: _scrollController,
          // add 1 to account for the LawTitleCard added at zeroth index
          itemCount: searchState.lawContents.length + 1,
          itemBuilder: (context, index) {
            return _buildListItem(index, context, userFavorites);
          },
        );
      },
    );
  }

  Widget _buildListItem(
      int index, BuildContext context, Map<String, dynamic> userFavorites) {
    if (index == 0) return LawTitleCard(searchState.activeLaw);

    // subtract 1 to recover the zeroth index used by the LawTitleCard
    int articleIndex = index - 1;

    String articleNumber = searchState.lawContents.keys.toList()[articleIndex];

    return ArticleCardWithCornerIcons(
      position: articleIndex,
      lawNumber: searchState.activeLaw.number,
      articleNumber: articleNumber,
      articleText: searchState.lawContents[articleNumber],
      isStarred: _getStarredStatus(articleNumber, userFavorites),
      onArticleSelected: scrollToListItem,
      onSave: (favorite) => dbService.saveFavorite(favorite),
      onDelete: (favorite) => dbService.deleteFavorite(favorite),
      onSaveOrDeleteCompleted: _showSnackBar,
    );
  }

  bool _getStarredStatus(
      String articleNumber, Map<String, dynamic> userFavorites) {
    String dotlessLawNumber = searchState.activeLaw.number.replaceAll(".", "");
    String cardName = dotlessLawNumber + "&" + articleNumber;

    if (userFavorites.keys.toList().contains(cardName)) return true;
    return false;
  }

  _showSnackBar(Favorite favorite, BuildContext context,
      {onSave = false, onDelete = false}) {
    String snackBarText = "Artículo ${favorite.articleNumber} ";

    if (onSave) {
      snackBarText += 'guardado en favoritos';
    } else if (onDelete) {
      snackBarText += 'eliminado de favoritos';
    }

    final snackBar = SnackBar(
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

    Scaffold.of(context).showSnackBar(snackBar);
  }
}
