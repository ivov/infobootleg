import 'package:flutter/material.dart';
import 'package:infobootleg/helpers/retriever.dart';
import 'package:infobootleg/shared_widgets/law_card.dart';
import 'package:infobootleg/shared_widgets/law_title_card.dart';
import 'package:infobootleg/shared_widgets/modification_relations_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:infobootleg/models/search_state_model.dart';
import 'package:infobootleg/shared_widgets/law_frame.dart';
import 'package:infobootleg/helpers/hex_color.dart';

enum ModificationType { modifies, isModifiedBy }

class LawSummaryScreen extends StatelessWidget {
  LawSummaryScreen(this.searchState);

  final SearchStateModel searchState;

  @override
  Widget build(BuildContext context) {
    return LawFrame(
      pageController: searchState.pageController,
      returnLabelText: "buscador",
      frameContent: Column(
        children: [
          SizedBox(height: 15.0),
          LawTitleCard(searchState),
          SizedBox(height: 30.0),
          _buildLawDateRows(),
          SizedBox(height: 30.0),
          searchState.isLoading
              ? CircularProgressIndicator()
              : _buildLawAccessButton(context),
          SizedBox(height: 30.0),
          _buildSummaryText(context),
          SizedBox(height: 20.0),
          _buildModifiesRow(context),
          SizedBox(height: 20.0),
          _buildIsModifiedByRow(context),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Column _buildLawDateRows() {
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
            "Publicada el día ${searchState.activeLaw.gazetteDate}\nen el Boletín Oficial ${searchState.activeLaw.gazetteNumber} (pág. ${searchState.activeLaw.gazettePage})"),
        SizedBox(height: 10.0),
        _buildDateRow(MdiIcons.feather,
            "Sancionada el día ${searchState.activeLaw.enactmentDate}\npor el ${searchState.activeLaw.originatingBody}"),
      ],
    );
  }

  RaisedButton _buildLawAccessButton(BuildContext context) {
    return RaisedButton(
      elevation: 10.0,
      onPressed: () async {
        searchState.toggleLoadingState();
        await searchState.updateLawContents();
        searchState.goToLawTextScreen();
        searchState.toggleLoadingState();
      },
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
                    text: searchState.activeLaw.summaryText,
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
      builder: (_) => ModificationRelationsDialog(
        context: context,
        activeLaw: searchState.activeLaw,
        modificationType: modificationType,
        allRows: allRows,
      ),
    );
  }
}
