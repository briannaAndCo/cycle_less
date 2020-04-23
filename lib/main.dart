import 'package:flutter/material.dart';
import 'home_page.dart';
import 'app_defaults.dart' as AppDefaults;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pill Reminder',
      theme: ThemeData(
        primarySwatch: AppDefaults.getPrimarySwatchColor(),
        canvasColor: AppDefaults.getCanvasColor(),
        dialogBackgroundColor: AppDefaults.getDialogBackgroundColor(),
        cardColor: AppDefaults.getCardColor(),
        primaryIconTheme: IconThemeData(color: AppDefaults.getIconColor()),
        primaryTextTheme: TextTheme(
            title: TextStyle(color: AppDefaults.getPrimaryTextColor())),
        textTheme: TextTheme(
          body1: TextStyle(color: AppDefaults.getPrimaryTextColor(), fontSize: 18),
          caption: TextStyle(color: AppDefaults.getPrimaryTextColor(),),
          subhead: TextStyle(color: AppDefaults.getPrimaryTextColor(), fontSize: 18),
        ),
        dialogTheme: DialogTheme(
            titleTextStyle: TextStyle(
                color: AppDefaults.getPrimarySwatchColor(), fontSize: 18)),
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: AppDefaults.getPrimarySwatchColor())),
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: AppDefaults.getPrimarySwatchColor()))),
      ),
      home: HomePage(title: 'Pill Reminder'),
    );
  }
}
