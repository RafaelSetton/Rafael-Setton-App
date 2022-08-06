import 'package:flutter/material.dart';

final ThemeData light = ThemeData(
  brightness: Brightness.light,
  colorSchemeSeed: Colors.lightGreen,
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 2, 62, 21))),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 49, 157, 6))),
  ),
);

final ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  colorSchemeSeed: Colors.lightGreen,
);
