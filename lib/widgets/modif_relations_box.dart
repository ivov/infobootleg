import 'package:flutter/material.dart';

import 'package:infobootleg/utils/hex_color.dart';
import 'package:infobootleg/models/law_model.dart';
import 'package:infobootleg/screens/law_summary_screen.dart';

class ModifRelationsBox extends StatelessWidget {
  ModifRelationsBox({
    @required this.context,
    @required this.activeLaw,
    @required this.modificationType,
    @required this.allRows,
  });
  final BuildContext context;
  final Law activeLaw;
  final ModificationType modificationType;
  final Map<int, Map<String, String>> allRows;

  @override
  Widget build(BuildContext context) {
    if (allRows.length < 4) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogHeader(context),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildDialogTable(),
                ],
              ),
            ),
            _buildCloseDialogButton(context),
          ],
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDialogHeader(context),
          Container(
            height: 450.0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildDialogTable(),
                ],
              ),
            ),
          ),
          _buildCloseDialogButton(context),
        ],
      ),
    );
  }

  Container _buildDialogHeader(BuildContext context) {
    String modifText;
    if (modificationType == ModificationType.modifies) {
      modifText = "Normas que modifican\na la Ley ";
    } else if ((modificationType == ModificationType.isModifiedBy)) {
      modifText = "Normas que son modificadas\npor la Ley ";
    }

    return Container(
      height: 90,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Text(
        modifText + activeLaw.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDialogTable() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        border: TableBorder(
          horizontalInside: BorderSide(
            width: 1.2,
            color: Theme.of(context).primaryColor,
          ),
        ),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: _buildAllRows(),
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      children: [
        _buildHeaderCell("Norma"),
        _buildHeaderCell("Publicación"),
        _buildHeaderCell("Descripción")
      ],
    );
  }

  TableCell _buildHeaderCell(String headerText) {
    return TableCell(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          headerText,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  List<TableRow> _buildAllRows() {
    List<TableRow> allBuiltRows = allRows.keys
        .map((rowNumber) => _buildSingleTableRow(allRows[rowNumber]))
        .toList();
    allBuiltRows.insert(0, _buildHeaderRow());
    return allBuiltRows;
  }

  TableRow _buildSingleTableRow(Map<String, String> singleRow) {
    return TableRow(
      children: [
        TableCell(
          child: _buildCompoundCell(singleRow["firstCell"]),
        ),
        TableCell(
          child: _buildDateCell(singleRow["secondCell"]),
        ),
        TableCell(
          child: _buildCompoundCell(singleRow["thirdCell"]),
        )
      ],
    );
  }

  _buildDateCell(String cell) {
    Map<String, String> monthNumbers = {
      "ene": "01",
      "feb": "02",
      "mar": "03",
      "abr": "04",
      "may": "05",
      "jun": "06",
      "jul": "07",
      "ago": "08",
      "sep": "09",
      "oct": "10",
      "nov": "11",
      "dic": "12",
    };

    RegExp regexpForMonth = RegExp(r"-(.*)-");
    String month = regexpForMonth.firstMatch(cell).group(1);

    return Text(
      cell.replaceAll(regexpForMonth, "/${monthNumbers[month]}/"),
      textAlign: TextAlign.center,
    );
  }

  _buildCompoundCell(String cell) {
    List<String> cellParts = cell.split("__DIVIDER__");
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Text(
            cellParts[0],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              height: 1,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            cellParts[1],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
            ),
          )
        ],
      ),
    );
  }

  InkWell _buildCloseDialogButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: hexColor("50d890"),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: Text(
          "Cerrar",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
