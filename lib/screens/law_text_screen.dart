import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

import 'package:infobootleg/models/search_state_model.dart';
import 'package:infobootleg/widgets/article_card.dart';
import 'package:infobootleg/widgets/law_title_card.dart';
import 'package:infobootleg/widgets/table_of_contents.dart';

class LawTextScreen extends StatelessWidget {
  LawTextScreen(this.searchState);

  final SearchStateModel searchState;
  final ItemScrollController _scrollController = ItemScrollController();

  void scrollToListItem(int listItemPosition, {int milliseconds = 500}) {
    _scrollController.scrollTo(
      index: listItemPosition,
      duration: Duration(milliseconds: milliseconds),
    );
  }

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
        onTap: () => searchState.transitionToScreenVertically(Screen.summary),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_upward),
        onPressed: () =>
            searchState.transitionToScreenVertically(Screen.summary),
      ),
    );
  }

  _buildScrollablePositionedList(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemScrollController: _scrollController,
      itemCount: searchState.lawContents.length,
      itemBuilder: (context, index) {
        return _buildListItem(
          articleNumber: index.toString(),
        );
      },
    );
  }

  Widget _buildListItem({String articleNumber}) {
    if (articleNumber == "0") {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 30.0,
        ),
        child: LawTitleCard(searchState.activeLaw),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 7.5,
        horizontal: 10.0,
      ),
      child: ArticleCard(
        lawContents: searchState.lawContents,
        articleNumber: articleNumber,
        onArticleSelected: scrollToListItem,
      ),
    );
  }
}
