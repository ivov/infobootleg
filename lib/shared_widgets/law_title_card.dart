import 'package:flutter/material.dart';
import 'package:infobootleg/models/search_state_model.dart';

import 'law_card.dart';

class LawTitleCard extends StatelessWidget {
  LawTitleCard(this.searchState);
  final SearchStateModel searchState;

  @override
  Widget build(BuildContext context) {
    return LawCard(
      cardContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              "Ley " + searchState.activeLaw.number,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              searchState.activeLaw.summaryTitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              searchState.activeLaw.abstractTitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22),
            ),
          )
        ],
      ),
    );
  }
}
