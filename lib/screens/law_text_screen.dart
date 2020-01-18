import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

import 'package:infobootleg/models/search_state_model.dart';
import 'package:infobootleg/shared_widgets/article_card.dart';
import 'package:infobootleg/shared_widgets/law_title_card.dart';
import 'package:infobootleg/shared_widgets/table_of_contents.dart';

class LawTextScreen extends StatelessWidget {
  LawTextScreen(this.searchState);

  final SearchStateModel searchState;
  final ItemScrollController _scrollController = ItemScrollController();

  void scrollToArticle(int articlePosition) {
    _scrollController.scrollTo(
      index: articlePosition,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: TableOfContents(onArticleSelected: scrollToArticle),
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
        onTap: searchState.goToLawSummaryScreen,
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_upward),
        onPressed: searchState.goToLawSummaryScreen,
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
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        child: LawTitleCard(searchState),
      );
      // return _buildHeader();
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 15.0, left: 10.0, right: 10.0),
      child: ArticleCard(searchState.lawContents, articleNumber),
    );
  }
}
