import 'package:flutter/material.dart';
import 'home_page.dart';
import 'app_defaults.dart' as AppConstants;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pill Reminder',
      theme: ThemeData(
        primarySwatch: AppConstants.getPrimarySwatchColor(),
        canvasColor: AppConstants.getCanvasColor(),
        dialogBackgroundColor: AppConstants.getDialogBackgroundColor(),
        primaryIconTheme: IconThemeData(color: AppConstants.getIconColor()),
        primaryTextTheme: TextTheme(
            title: TextStyle(color: AppConstants.getPrimaryTextColor())),
        textTheme: TextTheme(
          body1: TextStyle(
              color: AppConstants.getPrimaryTextColor(), fontSize: 18),
          subhead: TextStyle(color: AppConstants.getPrimaryTextColor()),
        ),
      ),
      home: HomePage(title: 'Pill Reminder'),
    );
  }
}
