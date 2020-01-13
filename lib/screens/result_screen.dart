import 'package:flutter/material.dart';
import 'package:infobootleg/shared_widgets/beveled_frame.dart';
import 'package:infobootleg/models/law_model.dart';

class ResultScreen extends StatelessWidget {
  final Law currentLaw;

  ResultScreen(this.currentLaw);

  @override
  Widget build(BuildContext context) {
    String modifiesText;
    if (currentLaw.modifies == "0") {
      modifiesText = "Esta ley no modifica ni complementa\na ninguna norma.";
    } else if (currentLaw.modifies == "1") {
      modifiesText = "Esta ley modifica o complementa\na una norma.";
    } else {
      modifiesText =
          "Esta ley modifica o complementa\na ${currentLaw.modifies} normas.";
    }

    String isModifiedByText;
    if (currentLaw.isModifiedBy == "0") {
      isModifiedByText =
          "Esta ley no es modificada ni\ncomplementada por ninguna norma.";
    } else if (currentLaw.isModifiedBy == "1") {
      isModifiedByText =
          "Esta ley es modificada o complementada\npor una norma.";
    } else {
      isModifiedByText =
          "Esta ley es modificada o complementada\npor ${currentLaw.isModifiedBy} normas.";
    }

    dynamic formattedSummaryText = RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.body1,
        children: <TextSpan>[
          TextSpan(
            text: "RESUMEN: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: currentLaw.summaryText),
        ],
      ),
    );
    // currentLaw.summaryText

    return BeveledFrame([
      Padding(
        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Text(
          "Ley " + currentLaw.number,
          style: Theme.of(context).textTheme.headline,
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: Text(
          currentLaw.summaryTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.display1,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: Text(
          currentLaw.abstractTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.display2,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Text(
          "Publicada el día ${currentLaw.gazetteDate}\nen el Boletín Oficial ${currentLaw.gazetteNumber} (pág. ${currentLaw.gazettePage})",
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 25.0),
        child: Text(
          "Sancionada el día ${currentLaw.enactmentDate}\npor el ${currentLaw.originatingBody}",
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 25.0),
        child: MaterialButton(
          onPressed: () {},
          autofocus: true,
          color: Color(0xff5c8d89),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(25.0),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Text(
              "TEXTO COMPLETO DE LA LEY",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      Padding(
          padding: EdgeInsets.only(bottom: 15.0), child: formattedSummaryText
          // child: Text(
          //   currentLaw.summaryText,
          //   style: Theme.of(context).textTheme.body1,
          // ),
          ),
      Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: Text(
          modifiesText,
          textAlign: TextAlign.center,
        ),
      ),
      Text(
        isModifiedByText,
        textAlign: TextAlign.center,
      ),
    ], scrollable: true);
  }
}
