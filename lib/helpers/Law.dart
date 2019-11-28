import 'package:cloud_firestore/cloud_firestore.dart';

class Law {
  String number;
  String link;
  String gazetteDate;
  String enactmentDate;
  String modifies;
  String isModifiedBy;
  String gazetteNumber;
  String originatingBody;
  String gazettePage;
  String summaryText;
  String abstractTitle;
  String summaryTitle;

  Law.fromEmpty() {
    this.number = "";
    this.link = "";
    this.gazetteDate = "";
    this.enactmentDate = "";
    this.modifies = "";
    this.isModifiedBy = "";
    this.gazetteNumber = "";
    this.originatingBody = "";
    this.gazettePage = "";
    this.summaryText = "";
    this.abstractTitle = "";
    this.summaryTitle = "";
  }

  Law.fromFirestore(DocumentSnapshot doc) {
    this.link = doc.data["enlace"];
    this.gazetteDate = doc.data["fecha_boletin"];
    this.enactmentDate = doc.data["fecha_sancion"];

    this.modifies = doc.data["modifica_a"];
    this.isModifiedBy = doc.data["modificada_por"];

    this.gazetteNumber = doc.data["numero_boletin"];
    this.gazettePage = doc.data["pagina_boletin"];

    this.abstractTitle = doc.data["titulo_resumido"];
    this.summaryTitle = doc.data["titulo_sumario"];
    this.summaryText = doc.data["texto_resumido"];

    this.originatingBody = this.fixOriginatingBody(doc);
    this.number = this.fixLawNumber(doc);
  }

  String fixOriginatingBody(doc) {
    String originatingBody;
    if (doc.data["organismo_origen"] == "PODER EJECUTIVO NACIONAL (P.E.N.)") {
      originatingBody = "Poder Ejecutivo Nacional";
    } else if (doc.data["organismo_origen"] ==
        "HONORABLE CONGRESO DE LA NACION ARGENTINA") {
      originatingBody = "Honorable Congreso de la Nación Argentina";
    }
    return originatingBody;
  }

  String fixLawNumber(doc) {
    String lawNumber = doc.data["ley_numero"];
    if (lawNumber.length == 5) {
      return lawNumber.substring(0, 2) + "." + lawNumber.substring(2);
    }
    return lawNumber;
  }

  String toString() {
    return "---------\nLAW\nNUMBER: $number\nLINK: $link\nFECHA BO: $gazetteDate\n---------";
  }
}
