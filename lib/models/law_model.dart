class Law {
  Law(Map<String, dynamic> data) {
    link = data["enlace"];
    gazetteDate = data["fecha_boletin"];
    enactmentDate = data["fecha_sancion"];
    modifies = data["modifica_a"];
    isModifiedBy = data["modificada_por"];
    gazetteNumber = data["numero_boletin"];
    gazettePage = data["pagina_boletin"];
    abstractTitle = data["titulo_resumido"];
    summaryTitle = data["titulo_sumario"];
    summaryText = data["texto_resumido"];
    originatingBody = _fixOriginatingBody(data);
    number = _fixLawNumber(data);
  }

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

  String _fixOriginatingBody(Map<String, dynamic> data) {
    String originatingBody;
    if (data["organismo_origen"] == "PODER EJECUTIVO NACIONAL (P.E.N.)") {
      return "Poder Ejecutivo Nacional";
    } else if (data["organismo_origen"] ==
        "HONORABLE CONGRESO DE LA NACION ARGENTINA") {
      return "Honorable Congreso de la Nación Argentina";
    }
    return originatingBody;
  }

  String _fixLawNumber(Map<String, dynamic> data) {
    String lawNumber = data["ley_numero"];
    if (lawNumber.length == 5) {
      return lawNumber.substring(0, 2) + "." + lawNumber.substring(2);
    }
    return lawNumber;
  }

  String toString() {
    return "---------\nLAW\nNUMBER: $number\nLINK: $link\nFECHA BO: $gazetteDate\n---------";
  }
}
