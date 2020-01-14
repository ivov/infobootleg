import 'package:flutter/material.dart';

class LawCard extends StatelessWidget {
  LawCard({@required this.cardContent});
  final Widget cardContent;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        width: MediaQuery.of(context).size.width * 0.85,
        child: cardContent,
      ),
    );
  }
}
