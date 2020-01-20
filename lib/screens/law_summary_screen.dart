import 'package:flutter/material.dart';
import 'package:infobootleg/models/law_model.dart';
import 'package:infobootleg/widgets/alert_box.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:infobootleg/helpers/retriever.dart';
import 'package:infobootleg/widgets/basic_card.dart';
import 'package:infobootleg/widgets/law_title_card.dart';
import 'package:infobootleg/widgets/modif_relations_box.dart';
import 'package:infobootleg/models/search_state_model.dart';
import 'package:infobootleg/helpers/hex_color.dart';
import 'package:url_launcher/url_launcher.dart';

enum ModificationType { modifies, isModifiedBy }

class NoPatternMatchException implements Exception {
  NoPatternMatchException();
}

class LawSummaryScreen extends StatelessWidget {
  LawSummaryScreen(this.searchState);

  final SearchStateModel searchState;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Theme.of(context).canvasColor,
        body: _buildBody(context),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: GestureDetector(
        child: Text("Volver al buscador"),
        onTap: () => searchState.transitionToScreenVertically(Screen.search),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_upward),
        onPressed: () =>
            searchState.transitionToScreenVertically(Screen.search),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
            child: LawTitleCard(searchState.activeLaw),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: _buildLawDateRows(searchState.activeLaw),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: _buildLawAccessButton(context, searchState.isLoading),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: _buildSummaryRow(context),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: _buildModifiesRow(context),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
            child: _buildIsModifiedByRow(context),
          ),
        ],
      ),
    );
  }

  _buildLawDateRows(Law activeLaw) {
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _accessLaw(BuildContext context) async {
    searchState.toggleLoadingState();
    try {
      await searchState.updateLawContents();
      searchState.transitionToScreenVertically(Screen.text);
      searchState.toggleLoadingState();
    } on NoPatternMatchException {
      final bool answer = await AlertBox(
        title: "Formato desconocido",
        content:
            "La Ley ${searchState.activeLaw.number} tiene formato desconocido y la aplicación no puede procesarla. ¿Abrir esta ley en Infoleg en el navagador?",
        confirmActionText: "Sí",
        cancelActionText: "No",
      ).show(context);
      if (answer) {
        _launchURL(searchState.activeLaw.link);
      }
    } finally {
      searchState.toggleLoadingState();
    }
  }

  _buildLawAccessButton(BuildContext context, bool isLoading) {
    if (isLoading == true) {
      return CircularProgressIndicator();
    }

    return RaisedButton(
      onPressed: () => _accessLaw(context),
      elevation: 10.0,
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

  _buildSummaryRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BasicCard(
          cardContent: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: _buildSummaryText(context),
          ),
        ),
      ],
    );
  }

  _buildSummaryText(context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.body1,
        children: <TextSpan>[
          TextSpan(
            text: "RESUMEN: ",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: searchState.activeLaw.summaryText,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  _buildModifiesRow(BuildContext context) {
    bool modifiesEnabled = searchState.activeLaw.modifies != "0";

    IconData modifIcon = modifiesEnabled
        ? MdiIcons.chevronLeftCircle
        : MdiIcons.dotsHorizontalCircle;

    String _getModifiesText() {
      String modifiesText;
      if (searchState.activeLaw.modifies == "0") {
        modifiesText = "Esta ley no modifica a ninguna norma.";
      } else if (searchState.activeLaw.modifies == "1") {
        modifiesText = "Esta ley modifica a una norma.";
      } else {
        modifiesText =
            "Esta ley modifica a ${searchState.activeLaw.modifies} normas.";
      }
      return modifiesText;
    }

    Row modifiesRow = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          modifIcon,
          size: 35.0,
          color: modifiesEnabled ? Theme.of(context).primaryColor : Colors.grey,
        ),
        SizedBox(width: 16.0),
        Container(
          width: 280,
          child: Text(
            _getModifiesText(),
            style: TextStyle(fontSize: 18.0),
            textAlign: TextAlign.left,
          ),
        )
      ],
    );

    return modifiesEnabled
        ? GestureDetector(
            child: modifiesRow,
            onTap: () => _onModificationRelationsButtonPressed(
                  context,
                  ModificationType.modifies,
                ))
        : modifiesRow;
  }

  _buildIsModifiedByRow(BuildContext context) {
    bool isModifiedByEnabled = searchState.activeLaw.isModifiedBy != "0";

    IconData modifIcon = isModifiedByEnabled
        ? MdiIcons.chevronRightCircle
        : MdiIcons.dotsHorizontalCircle;

    String _getIsModifiedByText() {
      String isModifiedByText;
      if (searchState.activeLaw.isModifiedBy == "0") {
        isModifiedByText = "Esta ley no es modificada por ninguna norma.";
      } else if (searchState.activeLaw.isModifiedBy == "1") {
        isModifiedByText = "Esta ley es modificada por una norma.";
      } else {
        isModifiedByText =
            "Esta ley es modificada por ${searchState.activeLaw.isModifiedBy} normas.";
      }
      return isModifiedByText;
    }

    Row isModifiedByRow = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 280,
          child: Text(
            _getIsModifiedByText(),
            style: TextStyle(fontSize: 18.0),
            textAlign: TextAlign.end,
          ),
        ),
        SizedBox(width: 16.0),
        Icon(
          modifIcon,
          size: 35.0,
          color: isModifiedByEnabled
              ? Theme.of(context).primaryColor
              : Colors.grey,
        )
      ],
    );

    return isModifiedByEnabled
        ? GestureDetector(
            child: isModifiedByRow,
            onTap: () => _onModificationRelationsButtonPressed(
              context,
              ModificationType.isModifiedBy,
            ),
          )
        : isModifiedByRow;
  }

  void _onModificationRelationsButtonPressed(
      BuildContext context, ModificationType modificationType) async {
    Map<int, Map<String, String>> allRows =
        await Retriever.retrieveModificationRelations(
      fullTextUrl: searchState.activeLaw.link,
      modificationType: modificationType,
    );

    showDialog(
      context: context,
      builder: (_) => ModifRelationsBox(
        context: context,
        activeLaw: searchState.activeLaw,
        modificationType: modificationType,
        allRows: allRows,
      ),
    );
  }
}
