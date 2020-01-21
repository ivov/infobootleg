import 'package:flutter/material.dart';
import 'package:infobootleg/models/law_model.dart';
import 'package:infobootleg/widgets/basic_card.dart';

class LawTitleCard extends StatelessWidget {
  LawTitleCard(this.activeLaw);
  final Law activeLaw;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 30.0,
      ),
      child: BasicCard(
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
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                activeLaw.abstractTitle,
                style: TextStyle(fontSize: 22.0),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
