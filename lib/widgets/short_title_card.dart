import 'package:flutter/material.dart';

import 'package:infobootleg/widgets/basic_card.dart';

class ShortTitleCard extends StatelessWidget {
  ShortTitleCard({this.title});

  final String title;

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
                title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
