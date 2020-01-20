import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:infobootleg/models/favorite_model.dart';

import 'package:infobootleg/models/search_state_model.dart';
import 'package:infobootleg/services/database_service.dart';
import 'package:infobootleg/widgets/article_card.dart';
import 'package:infobootleg/widgets/law_title_card.dart';
import 'package:infobootleg/widgets/table_of_contents.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LawTextScreen extends StatefulWidget {
  LawTextScreen(this.searchState, this.dbService);

  final SearchStateModel searchState;
  final DatabaseService dbService;

  @override
  _LawTextScreenState createState() => _LawTextScreenState();
}

class _LawTextScreenState extends State<LawTextScreen> {
  final ItemScrollController _scrollController = ItemScrollController();
  Map<String, dynamic>
      userFavorites; // triggers rebuild on update at _updateUserFavorites from onYesAtSave and onYesAtDelete

  @override
  void initState() {
    super.initState();
    _getFavoritesObject().then((data) {
      setState(() => userFavorites = data);
    });
  }

  _updateUserFavorites() {
    _getFavoritesObject().then((data) {
      setState(() => userFavorites = data);
    });
  }

  Future<Map<String, dynamic>> _getFavoritesObject() async {
    DocumentSnapshot snapshot = await widget.dbService.readAllFavoritesOfUser();
    return snapshot.data;
  }

  void scrollToListItem(int listItemPosition, {int milliseconds = 500}) {
    _scrollController.scrollTo(
      index: listItemPosition,
      duration: Duration(milliseconds: milliseconds),
    );
  }

  // void saveFavorite(Favorite favorite) {
  //   widget.dbService.saveFavorite(favorite);
  // }

  // void deleteFavorite(Favorite favorite) {
  //   widget.dbService.deleteFavorite(favorite);
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: TableOfContents(onListItemSelected: scrollToListItem),
        appBar: _buildAppBar(),
        backgroundColor: Theme.of(context).canvasColor,
        body: _buildScrollablePositionedList(context),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: GestureDetector(
        child: Text("Volver al resumen"),
        onTap: () =>
            widget.searchState.transitionToScreenVertically(Screen.summary),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_upward),
        onPressed: () =>
            widget.searchState.transitionToScreenVertically(Screen.summary),
      ),
    );
  }

  _buildScrollablePositionedList(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemScrollController: _scrollController,
      itemCount: widget.searchState.lawContents.length,
      itemBuilder: (context, index) {
        return _buildListItem(
            articleNumber: index.toString(), context: context);
      },
    );
  }

  Widget _buildListItem(
      {@required String articleNumber, @required BuildContext context}) {
    if (articleNumber == "0") {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 30.0,
        ),
        child: LawTitleCard(widget.searchState.activeLaw),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 7.5,
        horizontal: 10.0,
      ),
      child: ArticleCard(
        lawNumber: widget.searchState.activeLaw.number,
        articleNumber: articleNumber,
        articleText: widget.searchState.lawContents[articleNumber],
        isStarred: _getStarredStatus(articleNumber),
        onArticleSelected: scrollToListItem,
        onYesAtSave: (favorite) => _onYesAtSave(favorite, context),
        onYesAtDelete: (favorite) => _onNoAtSave(favorite, context),
      ),
    );
  }

  bool _getStarredStatus(String articleNumber) {
    String dotlessLawNumber =
        widget.searchState.activeLaw.number.replaceAll(".", "");
    String cardName = dotlessLawNumber + "&" + articleNumber;
    if (userFavorites != null) {
      if (userFavorites.keys.toList().contains(cardName)) {
        return true;
      }
    }
    return false;
  }

  void _onYesAtSave(Favorite favorite, BuildContext context) async {
    await widget.dbService.saveFavorite(favorite);
    _updateUserFavorites();
    _showSnackBar(favorite, context, onSave: true);
  }

  void _onNoAtSave(Favorite favorite, BuildContext context) async {
    await widget.dbService.deleteFavorite(favorite);
    _updateUserFavorites();
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
