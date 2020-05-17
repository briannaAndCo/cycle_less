import 'package:flutter/material.dart';
import 'home_page.dart';
import 'app_defaults.dart' as AppDefaults;
import 'package:pill_reminder/data/pressed_pill.dart';
import 'dart:math';
import 'package:pill_reminder/data/database_defaults.dart' as DB;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  bool first = true;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    if(first)
      {
        for(PressedPill pill in _getValidContinuousUse21of28NoBreakYet())
          {
         //  print("Instering pill " + pill.toString());
        //   DB.insertPressedPill(pill);
          //  DB.deleteAllPressedPills();
          }
        first = false;
      }

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

  // Create a list of pressed pills where 21 valid pills have been taken
// but no break has been taken.
  List<PressedPill> _getValidContinuousUse21of28NoBreakYet() {
    List<PressedPill> list = new List();

    DateTime date = DateTime.now();
    Random generator = Random();
    bool active = false;
    for (int i = 21; i >= 1; i--) {
      //After pill 21 they become active.
      if (i <= 21) {
        active = true;
      }

      list.add(PressedPill(id: null, day: i, date: date, active: active));

      int hour = generator.nextInt(12);
      //Create 2 days with bad timing. This should make the protection compromised
      if (i == 2 || i == 20) {
        hour = 15;
      }

      date = date.subtract(Duration(days: 1, hours: hour));
    }

    return list;
  }
}
