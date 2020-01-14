import 'package:flutter/material.dart';

import 'package:infobootleg/screens/search_result_screen.dart';
import 'package:infobootleg/screens/search_start_screen.dart';
import 'package:infobootleg/models/law_model.dart';

import 'package:infobootleg/helpers/lawTextRetriever.dart';

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

  // temporary method - delete
  @override
  initState() {
    String url =
        "http://servicios.infoleg.gob.ar/infolegInternet/anexos/190000-194999/194196/norma.htm";
    super.initState();
    final retriever = LawTextRetriever(url: url);
    retriever.retrieveLawText();
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
