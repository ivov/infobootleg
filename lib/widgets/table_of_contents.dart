import 'package:flutter/material.dart';

class TableOfContents extends StatelessWidget {
  TableOfContents({
    @required this.onListItemSelected,
    @required this.drawerTitle,
    @required this.drawerSubtitle,
    @required this.drawerContents,
    this.isForFavoritesScreen = false,
    this.sortedKeys,
  });

  final Function onListItemSelected;
  final String drawerTitle;
  final String drawerSubtitle;
  final Map<String, dynamic> drawerContents;
  final bool isForFavoritesScreen;
  final List<String> sortedKeys; // TODO: user this

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: _buildDrawerSections(context),
      ),
    );
  }

  List<Widget> _buildDrawerSections(context) {
    Container drawerHeader = Container(
      height: 160.0,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
          onListItemSelected(0);
        },
        child: DrawerHeader(
          child: Column(
            children: [
              SizedBox(height: 15.0),
              Text(
                drawerTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                drawerSubtitle,
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
      ),
    );

    List<String> keysList = drawerContents.keys.toList();
    if (isForFavoritesScreen) {
      keysList = sortedKeys;
    }

    List<ListTile> drawerButtons = keysList.map(
      (key) {
        int index = keysList.indexOf(key);
        String drawerItemTitle;

        if (isForFavoritesScreen == false) {
          drawerItemTitle = "Artículo $key";
        } else if (isForFavoritesScreen == true) {
          String lawNumber = key.split("&")[0];
          String articleNumber = key.split("&")[1];
          drawerItemTitle = "Ley $lawNumber — Artículo $articleNumber";
        }

        return ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
          title: Text(
            drawerItemTitle,
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            drawerContents[key],
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(fontSize: 16.0),
          ),
          onTap: () {
            Navigator.of(context).pop();
            onListItemSelected(index);
          },
        );
      },
    ).toList();

    return [drawerHeader, ...drawerButtons];
  }
}
