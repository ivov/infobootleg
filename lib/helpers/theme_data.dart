import 'package:flutter/material.dart';
import 'package:infobootleg/helpers/hex_color.dart';

final themeData = ThemeData(
  primaryColor: hexColor("2c7873"),
  scaffoldBackgroundColor: hexColor("2c7873"),
  fontFamily: "Lusitana",
  textTheme: TextTheme(
    title: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),
    subtitle: TextStyle(fontSize: 20.0),
  ),
);

// const myColors = {
//   "backgroundColor": Color(0xfff4f9f4),
//   "accentColor": Color(0xff5c8d89),
//   "buttonColor": Color(0xff74b49b),
//   "cardColor": Color(0xffa7d7c5),
// };
