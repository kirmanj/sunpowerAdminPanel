import 'package:flutter/material.dart';

var lightThemeData = ThemeData(
  primarySwatch: Colors.blueGrey,
  backgroundColor: Colors.white,
  cardColor: Colors.blueGrey[50],
  primaryTextTheme: TextTheme(
    button: TextStyle(
      color: Colors.blueGrey,
      decorationColor: Colors.blueGrey[300],
    ),
    subtitle2: TextStyle(
      color: Colors.black87,
    ),
    subtitle1: TextStyle(
      color: Colors.black,
    ),
    headline1: TextStyle(color: Colors.black),
  ),
  bottomAppBarColor: Colors.blueGrey[900],
  iconTheme: IconThemeData(
    color: Colors.black87,
  ),
  brightness: Brightness.light,
);

var darkThemeData = ThemeData(
  primarySwatch: Colors.grey,
  backgroundColor: Colors.black87,
  cardColor: Colors.black,
  primaryTextTheme: TextTheme(
    button: TextStyle(
      color: Colors.blueGrey[200],
      decorationColor: Colors.blueGrey[50],
    ),
    subtitle2: TextStyle(
      color: Colors.white,
    ),
    subtitle1: TextStyle(
      color: Colors.white,
    ),
    headline1: TextStyle(
      color: Colors.white70,
    ),
  ),
  bottomAppBarColor: Colors.white,
  iconTheme: IconThemeData(
    color: Colors.black87,
  ),
  brightness: Brightness.dark,
);
