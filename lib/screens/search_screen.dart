import 'package:flutter/material.dart';
import 'package:infobootleg/search_box.dart';
import 'package:infobootleg/beveled_frame.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BeveledFrame([
      Text(
        "Infobootleg",
        style: Theme.of(context).textTheme.title,
      ),
      Text(
        "Buscador de legislación",
        style: Theme.of(context).textTheme.subtitle,
      ),
      SizedBox(
        height: 20,
      ),
      Searchbox()
    ]);
  }
}
