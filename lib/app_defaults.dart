library app_defaults;

import 'package:flutter/material.dart';

Color getPrimarySwatchColor() {
  return MaterialColor(
       0xff462c3d,
    <int, Color>{
      50: Color.fromRGBO(70, 44, 61, .1),
      100: Color.fromRGBO(70, 44, 61, .2),
      200: Color.fromRGBO(70, 44, 61, .3),
      300: Color.fromRGBO(70, 44, 61, .4),
      400: Color.fromRGBO(70, 44, 61, .5),
      500: Color.fromRGBO(70, 44, 61,.6),
      600: Color.fromRGBO(70, 44, 61, .7),
      700: Color.fromRGBO(70, 44, 61, .8),
      800: Color.fromRGBO(70, 44, 61, .9),
      900: Color.fromRGBO(70, 44, 61, 1),
    });
}

Color getCanvasColor() {
  return Color(0xff85687a);
}

Color getIconColor() {
  return Color(0xffc8b1b8);
}

Color getPrimaryTextColor() {
  return Color(0xffc8b1b8);
}

Color getDialogBackgroundColor() {
  return Colors.black54;
}

Color getCardColor() {
  return Colors.black26;
}

double getPrimaryFontSize() {
  return 18;
}

double getSecondaryFontSize() {
  return 14;
}

