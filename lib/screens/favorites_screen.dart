import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:infobootleg/services/firestore_database_service.dart';
import 'package:infobootleg/models/search_state_model.dart';
import 'package:infobootleg/widgets/short_title_card.dart';
import 'package:infobootleg/models/favorite_model.dart';
import 'package:infobootleg/widgets/article_card_with_corner_icons.dart';
import 'package:infobootleg/widgets/table_of_contents.dart';

class FavoritesScreen extends StatefulWidget {
  // Stateful because of the need to dispose of `_ScrollablePositionedListState`.
  // See: https://github.com/google/flutter.widgets/issues/24
  FavoritesScreen(this.searchState, this.dbService);

  final SearchStateModel searchState;
  final FirestoreDatabaseService dbService;

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  ItemScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ItemScrollController();
  }

  @override
  Widget build(BuildContext context) {
    // `StreamBuilder` is located up here rather than down below (as in LawTextScreen) because `TableOfContents` for `FavoritesScreen` needs access to `userFavorites`.
    return StreamBuilder(
      stream: widget.dbService.streamAllFavoritesOfUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        Map<String, dynamic> userFavorites = snapshot.data.data;

        /// Example of `userFavorites`
        /// ```
        /// {
        ///   "11723&3": { articleText: "Lorem ipsum...", comment: "Great!"},
        ///   "20305&5": { articleText: "Dolor sit amit..."},
        /// }
        /// ```

        Map<String, dynamic> flattenedFavorites =
            _flattenFavorites(userFavorites);
        List<String> sortedKeys = _sortFavorites(flattenedFavorites);
        return SafeArea(
          child: Scaffold(
            drawer: TableOfContents(
              onListItemSelected: _scrollToListItem,
              drawerTitle: "Favoritos",
              drawerSubtitle: "Índice de favoritos",
              drawerContents: flattenedFavorites,
              isForFavoritesScreen: true,
              sortedKeysForFavorites: sortedKeys,
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

  void _scrollToListItem(int index, {int milliseconds = 500}) {
    _scrollController.scrollTo(
      index:
          index + 1, // add 1 to account for FavoritesTitleCard at zeroth index
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
        onTap: () => widget.searchState.transitionHorizontallyTo(Screen.search),
      ),
      leading: IconButton(
        icon: Icon(MdiIcons.arrowLeft),
        onPressed: () =>
            widget.searchState.transitionHorizontallyTo(Screen.search),
      ),
    );
  }

  _buildScrollablePositionedList(BuildContext context,
      Map<String, dynamic> userFavorites, List<String> sortedKeys) {
    // add 1 to account for the FavoritesTitleCard added at zeroth index
    return ScrollablePositionedList.builder(
      itemScrollController: _scrollController,
      itemCount: userFavorites.length + 1,
      itemBuilder: (context, index) {
        return _buildListItem(context, index, userFavorites, sortedKeys);
      },
    );
  }

  Widget _buildListItem(BuildContext context, int index,
      Map<String, dynamic> userFavorites, List<String> sortedKeys) {
    if (index == 0) return ShortTitleCard(title: "Favoritos");

    // subtract 1 to recover the zeroth index used by FavoritesTitleCard
    int articleIndex = index - 1;

    String lawAndArticle = sortedKeys[articleIndex];
    String lawNumber = lawAndArticle.split("&")[0];
    String articleNumber = lawAndArticle.split("&")[1];
    String articleText = userFavorites[lawAndArticle]["articleText"];
    RichText favoriteText = _buildFavoriteText(articleText, lawNumber);

    return ArticleCardWithCornerIcons(
      position: articleIndex,
      lawNumber: lawNumber,
      articleNumber: articleNumber,
      articleText: articleText,
      comment: userFavorites[lawAndArticle]["comment"],
      isStarred: true,
      onArticleSelected: _scrollToListItem,
      onSave: (favorite) => widget.dbService.saveFavorite(favorite),
      onDelete: (favorite) => widget.dbService.deleteFavorite(favorite),
      onSaveOrDeleteCompleted: _showSnackBar,
      forFavoritesScreen: true,
      favoriteText: favoriteText,
      onCommentPressed: () {
        widget.searchState.updateArticleToComment({
          "lawNumber": lawNumber,
          "articleNumber": articleNumber,
          "articleText": articleText,
          "favoriteText": favoriteText, // ← RichText
        });
        widget.searchState.transitionHorizontallyTo(Screen.comment);
      },
    );
  }

  _buildFavoriteText(String articleText, String lawNumber) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.body1,
        children: [
          TextSpan(
            text: articleText,
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
