import 'package:flutter/material.dart';

import 'package:infobootleg/models/search_state_model.dart';
import 'package:provider/provider.dart';

// https://api.flutter.dev/flutter/widgets/ScrollController-class.html
// https://api.flutter.dev/flutter/widgets/ScrollPosition-class.html
// https://medium.com/flutter-community/scrolling-animation-in-flutter-6a6718b8e34f

class TableOfContents extends StatelessWidget {
  // _scrollController.attach(??); // ScrollPosition

  @override
  Widget build(BuildContext context) {
    final SearchStateModel searchState = Provider.of<SearchStateModel>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: _buildDrawerSections(searchState, context),
      ),
    );
  }

  List<Widget> _buildDrawerSections(SearchStateModel searchState, context) {
    Container drawerHeader = Container(
      height: 160.0,
      child: DrawerHeader(
        child: Column(
          children: [
            SizedBox(height: 15.0),
            Text(
              "Ley " + searchState.activeLaw.number,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "Índice de artículos",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );

    List<ListTile> drawerButtons = searchState.lawContents.keys
        .map(
          (articleNumber) => ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
            title: Text(
              "Artículo $articleNumber",
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              searchState.lawContents[articleNumber],
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(fontSize: 16.0),
            ),
            onTap: () {
              Navigator.of(context).pop();
              searchState.goToArticle(); // TODO: Scroll to article position
            },
          ),
        )
        .toList();

    return [drawerHeader, ...drawerButtons];
  }
}

RichText x = RichText(
  overflow: TextOverflow.ellipsis,
  text: TextSpan(
    children: [
      TextSpan(
        text: "Artículo: 2",
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text:
            "lsajn(sadkjfn(alskjdfnlkasjdfnlkasjdlkasjdfnladskjfnlaskjfnlaskdjfn",
        style: TextStyle(fontSize: 16.0),
      )
    ],
  ),
);
