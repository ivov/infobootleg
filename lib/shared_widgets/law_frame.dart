import 'package:flutter/material.dart';
import 'package:infobootleg/helpers/hex_color.dart';

class LawFrame extends StatelessWidget {
  LawFrame({
    @required this.frameContent,
    @required this.pageController,
    @required this.returnLabelText,
  });
  final Widget frameContent;
  final PageController pageController;
  final String returnLabelText;

  void _returnToPreviousScreen() {
    int screenIndex;
    if (returnLabelText == "buscador") {
      screenIndex = 0;
    } else if (returnLabelText == "resumen") {
      screenIndex = 1;
    }

    pageController.animateToPage(
      screenIndex,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOutQuint,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            child: Text("Volver al $returnLabelText"),
            onTap: _returnToPreviousScreen,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_upward),
            onPressed: _returnToPreviousScreen,
          ),
        ),
        body: Container(
          color: hexColor("f5eaea"),
          child: SingleChildScrollView(child: frameContent),
        ),
      ),
    );
  }
}
