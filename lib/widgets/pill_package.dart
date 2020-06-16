import 'package:flutter/material.dart';
import 'dart:async';
import '../data/pressed_pill.dart';
import 'pill.dart';
import '../data/database_defaults.dart' as DatabaseDefaults;
import '../app_defaults.dart' as AppDefaults;

class PillPackage extends StatefulWidget {
  PillPackage({Key key, this.alarmTime, this.pressedPills, this.totalWeeks, this.placeboDays, this.refreshDataCall}) : super(key: key);

  final List<PressedPill> pressedPills;
  final int totalWeeks;
  final int placeboDays;
  final TimeOfDay alarmTime;
  final Function refreshDataCall;

  @override
  _PillPackageState createState() => _PillPackageState();
}

class _PillPackageState extends State<PillPackage> {

  Map<int, PressedPill> _currentPackage = new Map();

  @override
  Widget build(BuildContext context) {

          Widget body;

          if (widget.pressedPills != null) {

            body = GridView.count(
                primary: false,
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                crossAxisCount: 7,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                childAspectRatio: 1,
                children: getPills(widget.pressedPills));
          } else {
            body = Container();
          }

          return Center(
            child: body,
          );
  }

  List<Widget> getPills(pressedPills) {
    int partialWeekActivePills = 7 - widget.placeboDays;
    int activePills =
        widget.totalWeeks * 7 - widget.placeboDays - partialWeekActivePills;

    // Because the package is a grid that fills from top to bottom,
    // The first day in the grid is a 7. This is decreased until day 0,
    // then the next columns last day is calculated
    int day = 7;
    int column = 1;
    void _calculateDay() {
      day--;
      if (day % 7 == 0) {
        day = column * 7 + 7;
        column++;
      }
    }

    _updateCurrentPackage(pressedPills);

    //Because the grid fills from top to bottom, the last active pills
    // must be put before the last active pills if there are any partial week active pills.
    List<Widget> pills = List<Widget>();

    for (int i = 0; i < activePills; i++) {
      pills.add(_createPill(day, true));
      _calculateDay();
    }

    for (int i = 0; i < widget.placeboDays; i++) {
      pills.add(_createPill(day, false));
      _calculateDay();
    }

    for (int i = 0; i < partialWeekActivePills; i++) {
      pills.add(_createPill(day, true));
      _calculateDay();
    }

    return pills;
  }

  Pill _createPill(int day, bool isActive) {
    return new Pill(
        id: _id(day),
        day: day,
        date: _date(day),
        isActive: _isActive(isActive, day),
        isPressed: _isPressed(day),
        alarmTime: widget.alarmTime,
        refreshDataCall: widget.refreshDataCall);
  }

  void _updateCurrentPackage(pressedPills) {
    // Calculate the pill states
    // Get the pressed pills that correspond to the current package.
    // Since the dates are descending, add all the pills until the first
    // pill in the package (pill 1) is encountered. After that, all the pill values are old.
    _currentPackage = new Map();

    for (PressedPill pill in pressedPills) {
      _currentPackage[pill.day] = pill;

      if (pill.day == 1) {
        break;
      }
    }



  }


  //Utility methods to read out the values for any past pressed pills
  bool _isPressed(day) {
    return (_currentPackage.containsKey(day));
  }

  bool _isActive(defaultVal, day) {
    if (_currentPackage.containsKey(day)) {
      return _currentPackage[day].active;
    }
    return defaultVal;
  }

  int _id(day) {
    if (_currentPackage.containsKey(day)) {
      return _currentPackage[day].id;
    }
    return null;
  }

  DateTime _date(day) {
    if (_currentPackage.containsKey(day)) {
      return _currentPackage[day].date;
    }
    return null;
  }

  Future<List<PressedPill>> _loadPressedPills() async {
    //Only bother loading the last package worth of pressed pills
    int maxRetrieve = widget.totalWeeks * 7;
    List<PressedPill> pills =
        await DatabaseDefaults.retrievePressedPills(maxRetrieve);
    return pills;
  }
}
