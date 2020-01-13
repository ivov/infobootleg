import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:infobootleg/helpers/hex_color.dart';
import 'package:infobootleg/models/law_model.dart';

class SearchResultScreen extends StatelessWidget {
  SearchResultScreen({@required this.activeLaw, @required this.pageController});
  final PageController pageController;
  final Law activeLaw;

  @override
  Widget build(BuildContext context) {
    return LawFrame(
      pageController: pageController,
      frameContent: Column(
        children: [
          SizedBox(height: 15.0),
          _buildLawTitleCard(context),
          SizedBox(height: 30.0),
          _buildLawDates(),
          SizedBox(height: 30.0),
          _buildLawAccessButton(context),
          SizedBox(height: 30.0),
          _buildSummaryText(context),
          SizedBox(height: 20.0),
          _buildModifiesLine(),
          SizedBox(height: 10.0),
          _buildIsModifiedByLine(),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  LawCard _buildLawTitleCard(BuildContext context) {
    return LawCard(
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
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              activeLaw.abstractTitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22),
            ),
          )
        ],
      ),
    );
  }

  Column _buildLawDates() {
    return Column(
      children: <Widget>[
        _buildDateRow(MdiIcons.scriptTextOutline,
            "Publicada el día ${activeLaw.gazetteDate}\nen el Boletín Oficial ${activeLaw.gazetteNumber} (pág. ${activeLaw.gazettePage})"),
        SizedBox(height: 10.0),
        _buildDateRow(MdiIcons.feather,
            "Sancionada el día ${activeLaw.enactmentDate}\npor el ${activeLaw.originatingBody}"),
      ],
    );
  }

  _buildDateRow(IconData icon, String dateText) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 35.0),
        SizedBox(width: 16.0),
        Container(
          width: 280,
          child: Text(
            dateText,
            style: TextStyle(fontSize: 18.0),
            textAlign: TextAlign.start,
          ),
        )
      ],
    );
  }

  RaisedButton _buildLawAccessButton(BuildContext context) {
    return RaisedButton(
      elevation: 10.0,
      onPressed: () {
        print("hello");
      }, // TODO: Access full text of law
      autofocus: true,
      color: hexColor("2c7873"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(MdiIcons.fileDocumentBoxMultipleOutline,
                size: 30.0, color: Colors.white),
            SizedBox(width: 10.0),
            Text(
              "Acceder al texto de la ley",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryText(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LawCard(
          cardContent: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.body1,
                children: <TextSpan>[
                  TextSpan(
                    text: "RESUMEN: ",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: activeLaw.summaryText,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Text _buildIsModifiedByLine() {
    return Text(
      _getIsModifiedByText(),
      style: TextStyle(fontSize: 18.0),
      textAlign: TextAlign.center,
    );
  }

  Text _buildModifiesLine() {
    return Text(
      _getModifiesText(),
      style: TextStyle(fontSize: 18.0),
      textAlign: TextAlign.center,
    );
  }

  String _getModifiesText() {
    String modifiesText;
    if (activeLaw.modifies == "0") {
      modifiesText = "Esta ley no modifica ni complementa\na ninguna norma.";
    } else if (activeLaw.modifies == "1") {
      modifiesText = "Esta ley modifica o complementa\na una norma.";
    } else {
      modifiesText =
          "Esta ley modifica o complementa\na ${activeLaw.modifies} normas.";
    }
    return modifiesText;
  }

  String _getIsModifiedByText() {
    String isModifiedByText;
    if (activeLaw.isModifiedBy == "0") {
      isModifiedByText =
          "Esta ley no es modificada ni\ncomplementada por ninguna norma.";
    } else if (activeLaw.isModifiedBy == "1") {
      isModifiedByText =
          "Esta ley es modificada o complementada\npor una norma.";
    } else {
      isModifiedByText =
          "Esta ley es modificada o complementada\npor ${activeLaw.isModifiedBy} normas.";
    }
    return isModifiedByText;
  }
}

class LawFrame extends StatelessWidget {
  LawFrame({@required this.frameContent, @required this.pageController});
  final Widget frameContent;
  final PageController pageController;

  void _returnToSearchStartScreen() {
    pageController.animateToPage(
      0,
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
            child: Text("Volver al buscador"),
            onTap: _returnToSearchStartScreen,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_upward),
            onPressed: _returnToSearchStartScreen,
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
