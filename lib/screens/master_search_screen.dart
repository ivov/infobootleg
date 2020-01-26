import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infobootleg/screens/comment_screen.dart';
import 'package:provider/provider.dart';

import 'package:infobootleg/screens/favorites_screen.dart';
import 'package:infobootleg/services/database_service.dart';
import 'package:infobootleg/models/search_state_model.dart';
import 'package:infobootleg/screens/law_search_screen.dart';
import 'package:infobootleg/screens/law_summary_screen.dart';
import 'package:infobootleg/screens/law_text_screen.dart';

class MasterSearchScreen extends StatelessWidget {
  static createWithMultiProvider(BuildContext context, FirebaseUser user) {
    return MultiProvider(
      providers: [
        Provider<DatabaseService>(
          builder: (context) => DatabaseService(currentUserID: user.uid),
        ),
        ChangeNotifierProvider<SearchStateModel>(
          builder: (context) => SearchStateModel(),
        )
      ],
      child: MasterSearchScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = Provider.of<SearchStateModel>(context);
    final dbService = Provider.of<DatabaseService>(context);

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
            LawSearchScreen(searchState, dbService),
            FavoritesScreen(searchState, dbService),
            CommentScreen(searchState),
          ],
        ),
        LawSummaryScreen(searchState),
        LawTextScreen(searchState, dbService),
      ],
    );
  }
}
