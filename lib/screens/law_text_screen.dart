import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

import 'package:infobootleg/models/search_state_model.dart';
import 'package:infobootleg/shared_widgets/law_title_card.dart';
import 'package:infobootleg/shared_widgets/table_of_contents.dart';

class LawTextScreen extends StatelessWidget {
  LawTextScreen(this.searchState);

  final SearchStateModel searchState;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: TableOfContents(),
        appBar: _buildAppBar(),
        body: Container(
          color: Theme.of(context).canvasColor,
          child: buildContent(context),
        ),
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

  Widget buildContent(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Expanded(child: _buildScrollablePositionedList(context)),
        ],
      ),
    );
  }

  ScrollablePositionedList _buildScrollablePositionedList(
      BuildContext context) {
    ItemScrollController _scrollController = ItemScrollController();

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

  Column _buildListItem({String articleNumber}) {
    if (articleNumber == "0") {
      return _buildHeader();
    } else {
      return Column(
        children: [_buildArticleCard(articleNumber), SizedBox(height: 15.0)],
      );
    }
  }

  Column _buildHeader() {
    return Column(
      children: [
        SizedBox(height: 15.0),
        LawTitleCard(searchState),
        SizedBox(height: 15.0)
      ],
    );
  }

  Card _buildArticleCard(articleNumber) {
    return Card(
      elevation: 5.0,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Text(
              "Art.\n" + articleNumber,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                searchState.lawContents[articleNumber],
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
