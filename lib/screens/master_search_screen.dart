import 'package:flutter/material.dart';
import 'package:infobootleg/screens/favorites_screen.dart';
import 'package:provider/provider.dart';

import 'package:infobootleg/models/search_state_model.dart';
import 'package:infobootleg/screens/law_search_screen.dart';
import 'package:infobootleg/screens/law_summary_screen.dart';
import 'package:infobootleg/screens/law_text_screen.dart';

class MasterSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final searchState = Provider.of<SearchStateModel>(context);

    return PageView(
      controller: searchState.verticalPageViewController,
      scrollDirection: Axis.vertical,
      physics:
          NeverScrollableScrollPhysics(), // prevents manual PageView transition
      children: <Widget>[
        PageView(
          controller: searchState.horizontalPageViewController,
          scrollDirection: Axis.horizontal,
          physics:
              NeverScrollableScrollPhysics(), // prevents manual PageView transition
          children: [
            LawSearchScreen(searchState),
            FavoritesScreen(),
          ],
        ),
        LawSummaryScreen(searchState),
        LawTextScreen(searchState),
      ],
    );
  }
}
