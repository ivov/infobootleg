import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:infobootleg/services/database_service.dart';
import 'package:infobootleg/models/search_state_model.dart';
import 'package:infobootleg/widgets/favorites_title_card.dart';
import 'package:infobootleg/models/favorite_model.dart';
import 'package:infobootleg/widgets/article_card.dart';
import 'package:infobootleg/widgets/table_of_contents.dart';

// TODO: Add comments to favorites.

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen(this.searchState, this.dbService);

  final SearchStateModel searchState;
  final DatabaseService dbService;
  final ItemScrollController _scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    // StreamBuilder located here and not below because `TableOfContents` of favorites needs access to `userFavorites`

    return StreamBuilder(
      stream: dbService.streamAllFavoritesOfUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        Map<String, dynamic> userFavorites = snapshot.data.data;
        Map<String, dynamic> flattenedFavorites =
            _flattenFavorites(userFavorites);
        List<String> sortedKeys = _sortFavorites(flattenedFavorites);
        return SafeArea(
          child: Scaffold(
            drawer: TableOfContents(
              onListItemSelected: scrollToListItem,
              drawerTitle: "Favoritos",
              drawerSubtitle: "Índice de favoritos",
              drawerContents: flattenedFavorites,
              isForFavoritesScreen: true,
              sortedKeys: sortedKeys,
            ),
            appBar: _buildAppBar(),
            backgroundColor: Theme.of(context).canvasColor,
            body: _buildScrollablePositionedList(
                context, userFavorites, sortedKeys),
          ),
        );
      },
    );
  }

  void scrollToListItem(int index, {int milliseconds = 500}) {
    _scrollController.scrollTo(
      index: index + 1, // add 1 to account for header at zeroth index
      duration: Duration(milliseconds: milliseconds),
    );
  }

  /// Flattens `userFavorites` into a Map acceptable by `drawerContents` of `TableOfContents`.
  Map<String, dynamic> _flattenFavorites(Map<String, dynamic> userFavorites) {
    Map<String, dynamic> flattenedFavorites = {};
    userFavorites.keys.forEach((key) {
      flattenedFavorites[key] = userFavorites[key]["articleText"];
    });
    return flattenedFavorites;
  }

  /// Sorts Map of `flattenedFavorites` by law number and, in same law, by article number.
  List<String> _sortFavorites(Map<String, dynamic> flattenedFavorites) {
    return flattenedFavorites.keys.toList()
      ..sort((a, b) {
        int lawNumber1 = int.parse(a.split("&")[0]);
        int lawNumber2 = int.parse(b.split("&")[0]);
        int lawComparisonResult = lawNumber1.compareTo(lawNumber2);

        // same law
        if (lawComparisonResult == 0) {
          int articleNumber1 = int.parse(a.split("&")[1]);
          int articleNumber2 = int.parse(b.split("&")[1]);
          return articleNumber1.compareTo(articleNumber2);
        }

        return lawComparisonResult;
      });
  }

  _buildAppBar() {
    return AppBar(
      title: GestureDetector(
        child: Text("Volver al buscador"),
        onTap: () => searchState.transitionToScreenHorizontally(Screen.search),
      ),
      leading: IconButton(
        icon: Icon(MdiIcons.arrowLeft),
        onPressed: () =>
            searchState.transitionToScreenHorizontally(Screen.search),
      ),
    );
  }

  _buildScrollablePositionedList(BuildContext context,
      Map<String, dynamic> userFavorites, List<String> sortedKeys) {
    // add 1 to account for the list item header added at zeroth index
    return ScrollablePositionedList.builder(
      itemScrollController: _scrollController,
      itemCount: userFavorites.length + 1,
      itemBuilder: (context, index) {
        return _buildListItem(index, context, userFavorites, sortedKeys);
      },
    );
  }

  Widget _buildListItem(int index, BuildContext context,
      Map<String, dynamic> userFavorites, List<String> sortedKeys) {
    if (index == 0) return FavoritesTitleCard();

    // subtract 1 to recover the zeroth index used by the list item header
    int articleIndex = index - 1;

    String lawAndArticle = sortedKeys[articleIndex];
    String lawNumber = lawAndArticle.split("&")[0];
    String articleNumber = lawAndArticle.split("&")[1];
    String articleText = userFavorites[lawAndArticle]["articleText"];

    RichText favoriteText = RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.body1,
        children: [
          TextSpan(
            text: userFavorites[lawAndArticle]["articleText"],
            style: TextStyle(fontSize: 18.0),
          ),
          TextSpan(
            text: " — Ley $lawNumber",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 7.5,
        horizontal: 10.0,
      ),
      child: ArticleCard(
        position: articleIndex,
        lawNumber: lawNumber,
        articleNumber: articleNumber,
        articleText: articleText,
        isStarred: true,
        onArticleSelected: scrollToListItem,
        onSaveOrDelete: _showSnackBar,
        forFavoritesScreen: true,
        favoriteText: favoriteText,
        dbService: dbService,
      ),
    );
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
