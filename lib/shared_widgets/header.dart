import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  Header({@required BuildContext context, @required this.subtitleText});

  final String subtitleText;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: double.infinity),
      margin: EdgeInsets.only(right: 95.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(25.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Infobootleg", style: Theme.of(context).textTheme.title),
            SizedBox(height: 10.0),
            Text(subtitleText, style: Theme.of(context).textTheme.subtitle),
          ],
        ),
      ),
    );
  }
}
