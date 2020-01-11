import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    return int.parse("0xFF$hexColor");
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
