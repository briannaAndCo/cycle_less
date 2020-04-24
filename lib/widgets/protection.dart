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
    int totalPackageDays = widget.totalWeeks * 7;
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
    int activeTimeSpan = totalActiveDays -1;

    DateTime lastDate;
    DateTime currentDate;
    int count = 0;
    for (PressedPill pill in widget.pressedPills) {
      currentDate = pill.date;
      if (count > daysToCheck) {
        break;
      }
      //Count the first pill
      if (pill.active && lastDate == null) {
          activePillCount++;
      }
      else if (pill.active && lastDate != null) {
        activePillCount++;

        if (_isValidPill(currentDate, lastDate, timeWindow)) {
          validTimeSpan++;
        }
      }

      lastDate = currentDate;
      count++;
    }

    if (activePillCount >= totalActiveDays &&
        validTimeSpan >= activeTimeSpan ) {
      return ProtectionState.protected;
    } else if (activePillCount >= totalActiveDays &&
        validTimeSpan < activeTimeSpan) {
      return ProtectionState.compromised;
    }
    return ProtectionState.unprotected;
  }

  bool _isValidPill(DateTime currentDate, DateTime lastDate, double hours) =>
      _getHoursDifference(currentDate, lastDate) < hours;

  double _getHoursDifference(DateTime newDate, DateTime oldDate) {
    return (newDate.day - oldDate.day) * 24 +
        (newDate.hour - oldDate.hour) +
        (newDate.minute - oldDate.minute) / 60;
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