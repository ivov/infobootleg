import 'package:flutter/material.dart';
import 'package:infobootleg/helpers/hex_color.dart';
import 'package:infobootleg/widgets/table_of_contents.dart';

class LawFrame extends StatelessWidget {
  LawFrame({
    @required this.frameContent,
    @required this.pageController,
    @required this.returnLabelText,
    this.withDrawer = false,
  });
  final Widget frameContent;
  final PageController pageController;
  final String returnLabelText;
  final bool withDrawer;

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
    if (withDrawer) {
      return SafeArea(
        child: Scaffold(
          drawer: TableOfContents(),
          appBar: _buildAppBar(),
          body: Container(
            color: hexColor("f5eaea"),
            child: SingleChildScrollView(child: frameContent),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Container(
          color: hexColor("f5eaea"),
          child: SingleChildScrollView(child: frameContent),
        ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: GestureDetector(
        child: Text("Volver al $returnLabelText"),
        onTap: _returnToPreviousScreen,
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_upward),
        onPressed: _returnToPreviousScreen,
      ),
    );
  }
}
