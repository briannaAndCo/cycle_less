import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cycleless/model/pill_model.dart';
import 'package:cycleless/model/pill_package_model.dart';
import '../data/pressed_pill.dart';
import 'pill.dart';
import '../app_defaults.dart' as AppDefaults;

class PillPackage extends StatelessWidget {
  PillPackage(
      {Key key,
      this.alarmTime,
      this.newPack,
      this.miniPill,
      this.totalWeeks,
      this.placeboDays,
      this.pillPackageModel})
      : super(key: key);

  final bool newPack;
  final bool miniPill;
  final int totalWeeks;
  final int placeboDays;
  final TimeOfDay alarmTime;
  final PillPackageModel pillPackageModel;

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (_) => Center(
              child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                  crossAxisCount: 7,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  childAspectRatio: 1.2,
                  children: pillPackageModel.loadedPills == null
                      ? List<Widget>()
                      : _getPills()),
            ));
  }

  List<Widget> _getPills() {
    int partialWeekActivePills = 7 - placeboDays;
    int activePills = totalWeeks * 7 - placeboDays - partialWeekActivePills;

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
    List<Widget> widgetList = List<Widget>();

    widgetList.addAll(_createWeekdays());

    for (int i = 0; i < activePills; i++) {
      widgetList.add(_createPill(day, true));
      _calculateDay();
    }

    //If the mini pill value is true, the placbo pills do not exist and are
    // active
    bool active = miniPill ? true : false;
    for (int i = 0; i < placeboDays; i++) {
      widgetList.add(_createPill(day, active));
      _calculateDay();
    }

    for (int i = 0; i < partialWeekActivePills; i++) {
      widgetList.add(_createPill(day, true));
      _calculateDay();
    }

    return widgetList;
  }

  Iterable<Widget> _createWeekdays() {

    List<Widget> list = List<Widget>();

    DateTime dateTimeWeekday = (pillPackageModel.loadedPills != null &&
            pillPackageModel.loadedPills.length > 0)
        ? pillPackageModel.loadedPills.firstWhere((pill) => pill.day == 1).date
        : DateTime.now();

    for (int i = 0; i <= 6; i++) {
      list.add(Center(
          child: Wrap(direction: Axis.vertical, children: [
        RotatedBox(
            quarterTurns: 3,
            child: Text(_weekday(dateTimeWeekday.weekday),
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: AppDefaults.getSecondaryFontSize())))
      ])));
      dateTimeWeekday = dateTimeWeekday.add(Duration(days: 1));
    }

    //Return the list reversed because of the way it is displayed
    return list.reversed;
  }

  Widget _createPill(int day, bool isActive) {
    PillModel model = new PillModel();
    model.setId(_id(day));
    model.setDay(day);
    model.setCurrentDate(_date(day));
    model.setPressed(_isPressed(day));
    model.setIsActive(_isActive(isActive, day));

    return Pill(
        pillModel: model,
        alarmTime: alarmTime,
        pillPackageModel: pillPackageModel);
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
    for (PressedPill pill in pillPackageModel.loadedPills) {
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

  String _weekday(int val) {
    switch (val) {
      case 1:
        return "MON";
      case 2:
        return "TUES";
      case 3:
        return "WED";
      case 4:
        return "THUR";
      case 5:
        return "FRI";
      case 6:
        return "SAT";
      case 7:
        return "SUN";
    }
  }
}
