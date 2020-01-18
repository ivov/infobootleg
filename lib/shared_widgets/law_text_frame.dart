import 'package:flutter/material.dart';
import 'package:infobootleg/helpers/hex_color.dart';
import 'package:infobootleg/shared_widgets/table_of_contents.dart';

class LawTextFrame extends StatelessWidget {
  LawTextFrame({
    @required this.frameContent,
    @required this.pageController,
    @required this.returnLabelText,
  });
  final Widget frameContent;
  final PageController pageController;
  final String returnLabelText;

  void _returnToPreviousScreen() {
    pageController.animateToPage(
      1, // LawSummaryScreen
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOutQuint,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: TableOfContents(),
        appBar: _buildAppBar(),
        body: Container(
          color: hexColor("f5eaea"),
          child: frameContent,
        ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: GestureDetector(
        child: Text("Volver al resumen"),
        onTap: _returnToPreviousScreen,
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_upward),
        onPressed: _returnToPreviousScreen,
      ),
    );
  }
}
