import 'package:flutter/material.dart';
import 'package:infobootleg/helpers/hex_color.dart';

class BeveledFrame extends StatelessWidget {
  final List<Widget> children;
  final bool scrollable;

  BeveledFrame(this.children, {this.scrollable = false});

  @override
  Widget build(BuildContext context) {
    Widget column;

    // pending: jump to previous page on tap upwards
    final nonScrollableColumn = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );

    final scrollableColumn = ListView(children: children);

    if (scrollable == false) {
      column = nonScrollableColumn;
    } else if (scrollable == true) {
      column = scrollableColumn;
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.black, width: 15),
          ),
          child: ClipPath(
            clipper: ShapeBorderClipper(
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: Container(
              color: hexColor("f5eaea"),
              child: Padding(
                padding: EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 45.0),
                child: Center(
                  child: column,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
