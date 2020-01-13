import 'package:flutter/material.dart';

import 'package:infobootleg/screens/search_result_screen.dart';
import 'package:infobootleg/screens/search_start_screen.dart';
import 'package:infobootleg/models/law_model.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final PageController _pageController = PageController();
  Law activeLaw;

  void _setActiveLaw(Law selectedLaw) {
    setState(() => activeLaw = selectedLaw);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        SearchStartScreen(
          pageController: _pageController,
          onLawSelected: _setActiveLaw,
        ),
        SearchResultScreen(
          pageController: _pageController,
          activeLaw: activeLaw,
        ),
      ],
    );
  }
}
