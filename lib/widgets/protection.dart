import 'package:flutter/material.dart';
import '../data/pressed_pill.dart';

enum ProtectionState { protected, compromised, unprotected }
//24 hours + 12 hour window
const double COMBO_TIME_WINDOW = 36.0;
//24 hours + 3 hour window
const double MINI_TIME_WINDOW = 27.0;
//Days to become effective
const int COMBO_EFFECTIVE_DAYS = 7;
const int MINI_EFFECTIVE_DAYS = 2;

//The max number of late pills that can be taken in a pack.
const int MAX_LATE_PILLS = 2;

//If the pill package is extended (i.e, totalWeeks > 4, use this instead of the
// total weeks, since for protection, only the last 4 weeks count).
const int COMBO_STANDARD_PILL_PACKAGE = 4;

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
      //All mini pills are active, so just check if more time than the
      // window has elapsed
      if (_getHoursDifference(now, lastPillTime) > MINI_TIME_WINDOW) {
        return ProtectionState.unprotected;
      }

      //If the next pill is not active, check all days retrieved
      // (i.e. last package). Only the total active days must be effective
      return _checkDays(
          MINI_EFFECTIVE_DAYS, MINI_EFFECTIVE_DAYS, MINI_TIME_WINDOW);
    } else {
      // If the next is active and more time than the time window has elapsed
      // the default state is unprotected.
      if (isNextActive &&
          _getHoursDifference(now, lastPillTime) > COMBO_TIME_WINDOW) {
        return ProtectionState.unprotected;
      }

      //If the next pill is not active, check all days retrieved
      // (i.e. last package). Only the total active days must be effective
      if (!isNextActive) {
        return _checkDays(totalPackageDays, totalActiveDays, COMBO_TIME_WINDOW);
      }
      // Else if the next pill is active, check only the number of days
      // required to be effective. All the checked pills must be effective
      else {
        return _checkDays(
            COMBO_EFFECTIVE_DAYS, COMBO_EFFECTIVE_DAYS, COMBO_TIME_WINDOW);
      }
    }
  }

  ProtectionState _checkDays(
      int daysToCheck, int totalActiveDays, double timeWindow) {
    int activePillCount = 0;
    int validTimeSpan = 0;
    int activeTimeSpan = totalActiveDays - 1;

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

    if (activePillCount >= totalActiveDays && validTimeSpan >= activeTimeSpan) {
      return ProtectionState.protected;
      //Compromised state is not valid for mini pill
      //The pill is considered compromised if all pills have been taken but
      // all the pills were not valid time spans and the invalid time spans are
      // less than 3 for the full pack
    } else if (!widget.isMiniPill &&
        activePillCount >= totalActiveDays &&
        validTimeSpan < activeTimeSpan &&
        (activeTimeSpan - validTimeSpan <= MAX_LATE_PILLS)) {
      // Protection is compromised only if the last pill taken was active since
      // there is still time to correct it.If the last pill was a placebo,
      // then the state is unprotected.
      if (widget.pressedPills.length > 0 && widget.pressedPills[0].active) {
        return ProtectionState.compromised;
      }
      return ProtectionState.unprotected;
    }
    return ProtectionState.unprotected;
  }

  bool _isValidPill(DateTime currentDate, DateTime lastDate, double hours) =>
      _getHoursDifference(currentDate, lastDate) < hours;

  double _getHoursDifference(DateTime currentDate, DateTime lastDate) {
    double hours = (lastDate.day - currentDate.day) * 24 +
        (lastDate.hour - currentDate.hour) +
        (lastDate.minute - currentDate.minute) / 60;
    return hours;
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
