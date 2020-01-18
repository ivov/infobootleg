import 'package:flutter/material.dart';
import 'package:infobootleg/models/law_model.dart';
import 'package:infobootleg/widgets/basic_card.dart';

class LawTitleCard extends StatelessWidget {
  LawTitleCard(this.activeLaw);
  final Law activeLaw;

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      cardContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              "Ley " + activeLaw.number,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              activeLaw.summaryTitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              activeLaw.abstractTitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22),
            ),
          )
        ],
      ),
    );
  }
}
