import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:infobootleg/widgets/basic_card.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:infobootleg/models/favorite_model.dart';
import 'package:infobootleg/models/search_state_model.dart';
import 'package:infobootleg/services/database_service.dart';
import 'package:infobootleg/widgets/article_card.dart';
import 'package:infobootleg/widgets/table_of_contents.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen(this.searchState, this.dbService);

  final SearchStateModel searchState;
  final DatabaseService dbService;

  final ItemScrollController _scrollController = ItemScrollController();

  void scrollToListItem(int index, {int milliseconds = 500}) {
    _scrollController.scrollTo(
      index: index + 1, // add 1 to account for header at zeroth index
      duration: Duration(milliseconds: milliseconds),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: dbService.streamAllFavoritesOfUser(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          if (snapshot.data.data.isEmpty) return CircularProgressIndicator();
          Map<String, dynamic> userFavorites = snapshot.data.data;
          return SafeArea(
            child: Scaffold(
              drawer: TableOfContents(
                onListItemSelected: scrollToListItem,
                drawerTitle: "Favoritos",
                drawerSubtitle: "Índice de favoritos",
                drawerContents: _flattenFavorites(userFavorites),
                isForFavoritesScreen: true,
              ),
              appBar: _buildAppBar(),
              backgroundColor: Theme.of(context).canvasColor,
              body: _buildScrollablePositionedList(context, userFavorites),
            ),
          );
        });
  }

  // FLattens `userFavorites` into a Map acceptable by `drawerContents` of TableOfContents.
  Map<String, dynamic> _flattenFavorites(Map<String, dynamic> userFavorites) {
    Map<String, dynamic> flattenedFavorites = {};

    userFavorites.keys.forEach((key) {
      flattenedFavorites[key] = userFavorites[key]["articleText"];
    });
    return flattenedFavorites;
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

  _buildScrollablePositionedList(
      BuildContext context, Map<String, dynamic> userFavorites) {
    // add 1 to account for the list item header added at zeroth index
    return ScrollablePositionedList.builder(
      itemScrollController: _scrollController,
      itemCount: userFavorites.length + 1,
      itemBuilder: (context, index) {
        return _buildListItem(index, context, userFavorites);
      },
    );
  }

  _buildListItemHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 30.0,
      ),
      child: BasicCard(
        cardContent: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "Mis favoritos",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(
      int index, BuildContext context, Map<String, dynamic> userFavorites) {
    if (index == 0) {
      return _buildListItemHeader();
    }

    // new index only for articles, subtracting 1 to recover the zeroth index used by the list item header
    int articleIndex = index - 1;

    String lawAndArticle = userFavorites.keys.toList()[articleIndex];
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
        favoriteText: favoriteText,
        isStarred: true,
        onArticleSelected: scrollToListItem,
        onYesAtSave: (favorite) => _onYesAtSave(favorite, context),
        onYesAtDelete: (favorite) => _onNoAtSave(favorite, context),
        forFavoritesScreen: true,
      ),
    );
  }

  void _onYesAtSave(Favorite favorite, BuildContext context) async {
    await dbService.saveFavorite(favorite);
    _showSnackBar(favorite, context, onSave: true);
  }

  void _onNoAtSave(Favorite favorite, BuildContext context) async {
    await dbService.deleteFavorite(favorite);
    _showSnackBar(favorite, context, onDelete: true);
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
