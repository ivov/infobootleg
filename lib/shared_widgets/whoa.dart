import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

List<Widget> _myList = [
  Text("whoa1"),
  Text("whoa2"),
  Text("whoa3"),
];

whoa() {
  ItemScrollController _scrollController = ItemScrollController();
  ScrollablePositionedList.builder(
    itemScrollController: _scrollController,
    itemCount: _myList.length,
    itemBuilder: (context, index) {
      return _myList[index];
    },
  );
}
