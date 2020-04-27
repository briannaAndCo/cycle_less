import 'package:flutter/material.dart';
import '../data/pressed_pill.dart';

enum ProtectionState { protected, compromised, unprotected }
//24 hours + 12 hour window
const int COMBO_TIME_WINDOW = 36;
//24 hours + 3 hour window
const int MINI_TIME_WINDOW = 27;
//Pills taken to become effective
const int COMBO_EFFECTIVE_PILLS = 8;
const int MINI_EFFECTIVE_PILLS = 3;

//The max number of late pills that can be taken in a combo pack.
const int COMBO_MAX_LATE_PILLS = 2;

//If the pill package is extended (i.e, totalWeeks > 4, use this instead of the
// total weeks, since for protection, only the last 4 weeks count).
const int COMBO_STANDARD_PILL_PACKAGE = 4;

const int WEEK_DAY_COUNT = 7;

class Protection extends StatefulWidget {
  Protection(
      {Key key,
      this.pressedPills,
      this.totalWeeks,
      this.placeboDays,
      this.isMiniPill})
      : super(key: key);

  final List<PressedPill> pressedPills;
  final int totalWeeks;
  final int placeboDays;
  final bool isMiniPill;

  @override
  _ProtectionState createState() => _ProtectionState();
}

class _ProtectionState extends State<Protection> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = new List();

    if (widget.pressedPills != null) {
      ProtectionState state = getProtectionState();

      children = [
        Text(_getStateString(state)),
        Text(
          _getReasonString(state),
          softWrap: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        )
      ];
    } else {
      children = [
        Text("Unknown"),
        Text(
          "Could not load past pills.",
          textAlign: TextAlign.center,
        ),
      ];
    }

    return Card(
        child: Container(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: Column(
              children: children,
            )));
  }

  ProtectionState getProtectionState() {
    // Only the last four weeks count if the pill is an extended cycle
    // with more than four weeks.
    var effectivePackageWeeks = widget.totalWeeks > COMBO_STANDARD_PILL_PACKAGE
        ? COMBO_STANDARD_PILL_PACKAGE
        : widget.totalWeeks;
    int totalPackageDays = effectivePackageWeeks * 7;
    int totalActiveDays = totalPackageDays - widget.placeboDays;

    // If the pressed pills have not been loaded or there are no pressed pills
    // the user is not protected
    if (widget.pressedPills == null || widget.pressedPills.length == 0) {
      return ProtectionState.unprotected;
    }

    DateTime now = DateTime.now();

    //Get the last pill taken.
    PressedPill lastPill = widget.pressedPills[0];
    DateTime lastPillTime = lastPill.date;
    int day = lastPill.day;

    bool isNextActive = day < totalActiveDays;

    if (widget.isMiniPill) {
      // If not enough mini pills have been taken or the time window is passed
      // the state is unprotected.
      if (day < MINI_EFFECTIVE_PILLS ||
          _getHoursDifference(now, lastPillTime) > MINI_TIME_WINDOW) {
        return ProtectionState.unprotected;
      }

      return _checkDays(
          MINI_EFFECTIVE_PILLS, MINI_EFFECTIVE_PILLS, MINI_TIME_WINDOW);
    } else {
      //If less than the effective pills have been taken, the state is unprotected.
      if (day < COMBO_EFFECTIVE_PILLS) {
        return ProtectionState.unprotected;
      }
      // If the next is active and more time than the time window has elapsed
      // then check the last package window to find the protection state
      if (_getHoursDifference(now, lastPillTime) > COMBO_TIME_WINDOW) {
        return _checkDays(totalPackageDays, totalActiveDays, COMBO_TIME_WINDOW);
      }

      //If the next pill is not active, check all days retrieved
      // (i.e. last package).
      if (!isNextActive) {
        return _checkDays(totalPackageDays, totalActiveDays, COMBO_TIME_WINDOW);
      }
      // Else if the next pill is active, check as many pills as have been
      // taken from the pack.
      else {
        //Normalize for an extended cycle pill. This is the possible day active day count.
        int possibleTotalActiveDays =
            widget.totalWeeks * 7 - widget.placeboDays;

        //Find the difference between the possible and normalized active days.
        //This will be zero if the pill is not extended cycle.
        int difference = possibleTotalActiveDays - totalActiveDays;

        int daysToCheck = widget.pressedPills[0].day - difference;

        return _checkDays(daysToCheck, daysToCheck, COMBO_TIME_WINDOW);
      }
    }
  }

  ProtectionState _checkDays(
      int daysToCheck, int expectedActiveDays, int timeWindow) {
    int activePillCount = 0;
    int validTimeSpan = 0;
    int activeTimeSpan = expectedActiveDays - 1;

    bool lastActive = false;
    DateTime lastDate;
    int count = 0;
    for (PressedPill pill in widget.pressedPills) {
      if (count > daysToCheck) {
        break;
      }
      //Count the first pill
      if (pill.active) {
        activePillCount++;
      }
      //Else check if the valid time span between active pills is valid
      if (lastDate != null &&
          lastActive &&
          _isValidPill(pill.date, lastDate, timeWindow)) {
        validTimeSpan++;
      }

      lastDate = pill.date;
      lastActive = pill.active;
      count++;
    }

    int latePills = activeTimeSpan - validTimeSpan;
    bool lastWasActive = widget.pressedPills[0].active;

    //Check for the protected state. Only perfect use is protected.
    if (activePillCount >= expectedActiveDays && latePills <= 0) {
      return ProtectionState.protected;
    }
    //If the pill is a mini pill, then the state is unprotected.
    else if (widget.isMiniPill) {
      return ProtectionState.unprotected;
    }
    //Check for late pills.
    // If the pill is in week 1 and has any late pills the state is unprotected
    if (activePillCount <= COMBO_EFFECTIVE_PILLS && latePills > 0) {
      return ProtectionState.unprotected;
    }
    // If the pill is in week 2 and has 1 max missed time the state is compromised
    else if (lastWasActive &&
        activePillCount >= expectedActiveDays &&
        (activePillCount < COMBO_EFFECTIVE_PILLS + WEEK_DAY_COUNT) &&
        latePills <= 1) {
      return ProtectionState.compromised;
    }
    // If the pill is in week 3 or 4 and has 2 max missed time the state is compromised
    else if (lastWasActive &&
        activePillCount >= expectedActiveDays &&
        latePills <= 2) {
      return ProtectionState.compromised;
    }
    return ProtectionState.unprotected;
  }

  bool _isValidPill(DateTime currentDate, DateTime lastDate, int hours) =>
      _getHoursDifference(currentDate, lastDate) <= hours;

  int _getHoursDifference(DateTime currentDate, DateTime lastDate) {
    return lastDate.difference(currentDate).inHours.abs();
  }

  String _getReasonString(ProtectionState protectionState) {
    switch (protectionState) {
      case ProtectionState.protected:
        return "All pills have been taken correctly.";
        break;
      case ProtectionState.compromised:
        return "To many pills have been taken late or missed.\n"
            "Skip the placebo week and "
            "continue the next\npack to remain protected.";
        break;
      case ProtectionState.unprotected:
        return "Not enough pills have been taken correctly.\n "
            "Use backup protection for seven days.";
        break;
    }
    return "";
  }

  String _getStateString(ProtectionState protectionState) {
    switch (protectionState) {
      case ProtectionState.protected:
        return "Protected";
        break;
      case ProtectionState.compromised:
        return "Compromised";
        break;
      case ProtectionState.unprotected:
        return "Unprotected";
        break;
    }
    return "Unknown";
  }
}
