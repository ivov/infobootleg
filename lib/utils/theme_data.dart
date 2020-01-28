import 'package:flutter/material.dart';
import 'package:infobootleg/utils/hex_color.dart';

final themeData = ThemeData(
  primaryColor: hexColor("2c7873"),
  canvasColor: hexColor("f5eaea"),
  fontFamily: "Lusitana",
  textTheme: TextTheme(
    title: TextStyle(
      fontSize: 45.0,
      fontWeight: FontWeight.bold,
    ),
    subtitle: TextStyle(
      fontSize: 20.0,
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    contentTextStyle: TextStyle(fontFamily: "Lusitana"),
  ),
);
