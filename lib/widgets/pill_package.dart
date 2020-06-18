import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pill_reminder/model/new_pack_indicator.dart';
import 'package:pill_reminder/model/pill_model.dart';
import 'package:pill_reminder/model/pill_package_model.dart';
import 'dart:async';
import '../data/pressed_pill.dart';
import 'pill.dart';
import '../data/database_defaults.dart' as DatabaseDefaults;
import '../app_defaults.dart' as AppDefaults;

class PillPackage extends StatelessWidget {
  PillPackage(
      {Key key,
      this.alarmTime,
      this.pressedPills,
      this.newPack,
      this.totalWeeks,
      this.placeboDays,
      this.refreshDataCall})
      : super(key: key);

  final List<PressedPill> pressedPills;
  final bool newPack;
  final int totalWeeks;
  final int placeboDays;
  final TimeOfDay alarmTime;
  final Function refreshDataCall;
  final PillPackageModel pillPackageModel = new PillPackageModel();

  @override
  Widget build(BuildContext context) {
    Widget body;
    print("building: " + newPack.toString());
    if (pressedPills != null) {
      body = GridView.count(
          primary: false,
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          crossAxisCount: 7,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          childAspectRatio: 1,
          children: _getPills());
    } else {
      body = Container();
    }

    return Center(
      child: body,
    );
  }

  List<Widget> _getPills() {
    int partialWeekActivePills = 7 - placeboDays;
    int activePills =
        totalWeeks * 7 - placeboDays - partialWeekActivePills;

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

    _updateCurrentPackage();

    //Because the grid fills from top to bottom, the last active pills
    // must be put before the last active pills if there are any partial week active pills.
    List<Widget> pillList = List<Widget>();

    for (int i = 0; i < activePills; i++) {
      pillList.add(_createPill(day, true));
      _calculateDay();
    }

    for (int i = 0; i < placeboDays; i++) {
      pillList.add(_createPill(day, false));
      _calculateDay();
    }

    for (int i = 0; i < partialWeekActivePills; i++) {
      pillList.add(_createPill(day, true));
      _calculateDay();
    }

    return pillList;
  }

  Widget _createPill(int day, bool isActive) {

    PillModel model = new PillModel();
    model.setCurrentDate(_date(day));
    model.setPressed(_isPressed(day));

    return Observer(
        builder: (_) => Pill(
            key: Key("pill$day"),
            id: _id(day),
            day: day,
            isActive: _isActive(isActive, day),
            pillModel: model,
            alarmTime: alarmTime,
            refreshDataCall: refreshDataCall));
  }

  void _updateCurrentPackage() {
    // Calculate the pill states
    // Get the pressed pills that correspond to the current package.
    // Since the dates are descending, add all the pills until the first
    // pill in the package (pill 1) is encountered. After that, all the pill values are old.
    pillPackageModel.setCurrentPackage(new Map());

    if (newPack) return;

    //If the user has selected to start a new pack, don't use any taken pills
    // to create the package
    for (PressedPill pill in pressedPills) {
      pillPackageModel.currentPackage[pill.day] = pill;

      if (pill.day == 1) {
        break;
      }
    }
  }

  //Utility methods to read out the values for any past pressed pills
  bool _isPressed(day) {
    return pillPackageModel.currentPackage.containsKey(day);
  }

  bool _isActive(defaultVal, day) {
    if (pillPackageModel.currentPackage.containsKey(day)) {
      return pillPackageModel.currentPackage[day].active;
    }
    return defaultVal;
  }

  int _id(day) {
    if (pillPackageModel.currentPackage.containsKey(day)) {
      return pillPackageModel.currentPackage[day].id;
    }
    return null;
  }

  DateTime _date(day) {
    if (pillPackageModel.currentPackage.containsKey(day)) {
      return pillPackageModel.currentPackage[day].date;
    }
    return null;
  }

  Future<List<PressedPill>> _loadPressedPills() async {
    //Only bother loading the last package worth of pressed pills
    int maxRetrieve = totalWeeks * 7;
    List<PressedPill> pills =
        await DatabaseDefaults.retrievePressedPills(maxRetrieve);
    return pills;
  }
}
