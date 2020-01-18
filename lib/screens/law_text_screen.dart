import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

import 'package:infobootleg/models/search_state_model.dart';
import 'package:infobootleg/shared_widgets/law_frame.dart';
import 'package:infobootleg/shared_widgets/law_title_card.dart';

class LawTextScreen extends StatelessWidget {
  LawTextScreen(this.searchState);

  final SearchStateModel searchState;

  @override
  Widget build(BuildContext context) {
    // final SearchStateModel searchState = Provider.of<SearchStateModel>(context);
    // searchState.goToArticle();

    // if (true) {
    //   List<Widget> _myList = [
    //     Text("whoa1"),
    //     Text("whoa2"),
    //     Text("whoa3"),
    //   ];

    //   ItemScrollController _scrollController = ItemScrollController();
    //   return ScrollablePositionedList.builder(
    //     itemScrollController: _scrollController,
    //     itemCount: _myList.length,
    //     itemBuilder: (context, index) {
    //       return _myList[index];
    //     },
    //   );
    // }

    return LawFrame(
      withDrawer: true,
      frameContent: Container(
        width: double.infinity,
        child: Column(
          // TODO: ListView here so as to add scrollController?
          // https://stackoverflow.com/questions/49153087/flutter-scrolling-to-a-widget-in-listview
          children: <Widget>[
            SizedBox(height: 15.0),
            LawTitleCard(searchState),
            SizedBox(height: 15.0),
            _buildAllArticles(context),
          ],
        ),
      ),
      pageController: searchState.pageController,
      returnLabelText: "resumen",
    );
  }

  Container _buildAllArticles(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.92,
      child: Column(
        children: searchState.lawContents.keys
            .map((articleNumber) => _buildSingleArticle(articleNumber))
            .toList(),
      ),
    );
  }

  Column _buildSingleArticle(String articleNumber) {
    return Column(
      children: [
        Card(
          elevation: 5.0,
          child: Row(
            children: [
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Text("Art.\n" + articleNumber,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold))),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(searchState.lawContents[articleNumber],
                      style: TextStyle(fontSize: 18.0)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15.0)
      ],
    );
  }
}
