import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

import 'package:infobootleg/models/search_state_model.dart';
import 'package:infobootleg/services/database_service.dart';
import 'package:infobootleg/widgets/article_card.dart';
import 'package:infobootleg/widgets/law_title_card.dart';
import 'package:infobootleg/widgets/table_of_contents.dart';

class LawTextScreen extends StatefulWidget {
  LawTextScreen(this.searchState, this.dbService);

  final SearchStateModel searchState;
  final DatabaseService dbService;

  @override
  _LawTextScreenState createState() => _LawTextScreenState();
}

class _LawTextScreenState extends State<LawTextScreen> {
  final ItemScrollController _scrollController = ItemScrollController();
  Map<String, dynamic> userFavorites;

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
          articleNumber: index.toString(),
        );
      },
    );
  }

  bool _getStarredStatusBasedOnUserFavorites(String articleNumber) {
    String cardName = widget.searchState.activeLaw.number + "&" + articleNumber;
    if (userFavorites != null) {
      if (userFavorites.keys.toList().contains(cardName)) {
        return true;
      }
    }
    return false;
  }

  Widget _buildListItem({String articleNumber}) {
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
        isStarred: _getStarredStatusBasedOnUserFavorites(articleNumber),
        onArticleSelected: scrollToListItem,
        onYesAtSave: (favorite) {
          widget.dbService.saveFavorite(favorite);
          _updateUserFavorites();
        },
        onYesAtDelete: (favorite) {
          widget.dbService.deleteFavorite(favorite);
          _updateUserFavorites();
        },
      ),
    );
  }
}
