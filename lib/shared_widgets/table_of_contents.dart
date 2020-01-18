import 'package:flutter/material.dart';

import 'package:infobootleg/models/search_state_model.dart';
import 'package:provider/provider.dart';

class TableOfContents extends StatelessWidget {
  TableOfContents({this.onArticleSelected});

  final void Function(int) onArticleSelected;

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
              onArticleSelected(
                int.parse(articleNumber),
              );
            },
          ),
        )
        .toList();

    return [drawerHeader, ...drawerButtons];
  }
}
