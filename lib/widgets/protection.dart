import 'package:flutter/material.dart';
import '../data/pressed_pill.dart';
import 'package:number_to_words_spelling/number_to_words_spelling.dart';
import 'package:sprintf/sprintf.dart';

enum Status { protected, compromised, unprotected }
enum StatusInfo {
  unprotected_max_mini,
  unprotected_24_mini,
  protected_mini,
  unprotected_max_combo,
  unprotected_X_combo,
  compromised_combo,
  protected_combo,
  protected_can_break_combo,
  protected_on_break_combo,
  protected_on_break_24_combo,
  protected_must_resume_combo
}

class ProtectionStateInfo {
  ProtectionStateInfo({this.state, this.stateInfo});

  final Status state;
  final StatusInfo stateInfo;
}

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

//User text
const String PROTECTED_IN_24_HOURS =
    "Not enough pills have been taken correctly.\n"
    "Use backup protection for 24 hours.";
const String PROTECTED_IN_X_DAYS =
    "Not enough pills have been taken correctly.\n"
    "Use backup protection for %s days.";
const String PROTECTED_ALL_CORRECT = "All pills have been taken correctly.";
const String PROTECTED_BREAK_AVAILABLE =
    "A %s day break from active pills\nmay be taken any time.";
const String PROTECTED_MULTIPLE_DAYS_REMAINING =
    "There are %s protected days remaining.";
const String PROTECTED_24_HOURS_REMAINING =
    "There are 24 hours protected remaining.";
const String PROTECTED_NO_TIME_REMAINING =
    "To maintain protection, resume active pills.";
const String COMPROMISED_REASON =
    "Too many pills have been taken late or missed.\n"
    "Skip the placebo week and "
    "continue the next\npack to remain protected.";

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
    print("built");
    if (widget.pressedPills != null && widget.pressedPills.length > 1) {
      for (PressedPill pill in widget.pressedPills) {
        print(pill);
      }
    }

    if (widget.pressedPills != null) {
      ProtectionStateInfo info = _getProtectionState();
      children = [
        Text(
          _getStateString(info.state),
          style: _getTextStyle(info.state),
        ),
        Text(
          _getReasonString(info.stateInfo),
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

  ProtectionStateInfo _getProtectionState() {
    // Only the last four weeks count if the pill is an extended cycle
    // with more than four weeks.
    int totalPackageDays = _getEffectivePackageWeeks() * 7;
    int totalActiveDays = _getEffectiveTotalActiveDays();

    // If the pressed pills have not been loaded or there are no pressed pills
    // the user is not protected
    if (widget.pressedPills == null || widget.pressedPills.length == 0) {
      Status _state = Status.unprotected;
      StatusInfo _stateInfo = widget.isMiniPill
          ? StatusInfo.unprotected_max_mini
          : StatusInfo.unprotected_max_combo;
      return ProtectionStateInfo(state: _state, stateInfo: _stateInfo);
    }

    DateTime now = DateTime.now();

    //Get the last pill taken.
    PressedPill lastPill = widget.pressedPills[0];
    DateTime lastPillTime = lastPill.date;
    int day = lastPill.day;

    bool isNextActive = day < totalActiveDays;

    if (widget.isMiniPill) {
      // If the last mini pill was not taken orn time or not enough mini pills have been taken the state is unprotected.
      if (_getHoursDifference(now, lastPillTime) > MINI_TIME_WINDOW ||
          _getCurrentActivePillCount(MINI_TIME_WINDOW, true) <
              MINI_EFFECTIVE_PILLS) {
        Status _state = Status.unprotected;
        StatusInfo _stateInfo = StatusInfo.unprotected_max_mini;
        return ProtectionStateInfo(state: _state, stateInfo: _stateInfo);
      }

      return _checkDays(
          MINI_EFFECTIVE_PILLS, MINI_EFFECTIVE_PILLS, MINI_TIME_WINDOW);
    } else {
      // If the current active pills are less than those needed to be effective,
      // then the state is unprotected.
      if (_getCurrentActivePillCount(COMBO_TIME_WINDOW, true) <
          COMBO_EFFECTIVE_PILLS) {
        Status _state = Status.unprotected;
        StatusInfo _stateInfo = StatusInfo.unprotected_X_combo;
        return ProtectionStateInfo(state: _state, stateInfo: _stateInfo);
      }

      // If more time than the time window has elapsed or the next pill is inactive
      // or the user is continuous (i.e. more active pills in a row than
      // then check the last package window to find the protection state.
      //If the next pill is not active, check all days retrieved
      // (i.e. last package).
      if (_getHoursDifference(now, lastPillTime) > COMBO_TIME_WINDOW ||
          !isNextActive ||
          _getCurrentActivePillCount(COMBO_TIME_WINDOW, false) >
              totalActiveDays) {
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

  int _getEffectivePackageWeeks() {
    return widget.totalWeeks > COMBO_STANDARD_PILL_PACKAGE
        ? COMBO_STANDARD_PILL_PACKAGE
        : widget.totalWeeks;
  }

  ProtectionStateInfo _checkDays(
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
          pill.active &&
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
      Status _state = Status.protected;

      if (widget.isMiniPill) {
        StatusInfo _stateInfo = StatusInfo.protected_mini;
        return ProtectionStateInfo(state: _state, stateInfo: _stateInfo);
      }
      int packageTotalActiveDays = _getEffectiveTotalActiveDays();

      // If at least the required active days have been taken, the user may take
      // a break or be on one.
      if (activePillCount >= packageTotalActiveDays) {
        //The last pill taken in 24 hours was active and the user can break
        if (lastWasActive &&
            _getLastActiveDate().difference(DateTime.now()).inDays.abs() <= 1) {
          StatusInfo _stateInfo = StatusInfo.protected_can_break_combo;
          return ProtectionStateInfo(state: _state, stateInfo: _stateInfo);
        }
        //Else the user is in the middle of a break. Calculate the days left
        int daysLeftOnBreak = widget.placeboDays -
            _getLastActiveDate().difference(DateTime.now()).inDays.abs();

        if (daysLeftOnBreak >= 2) {
          StatusInfo _stateInfo = StatusInfo.protected_on_break_combo;
          return ProtectionStateInfo(state: _state, stateInfo: _stateInfo);
        } else if (daysLeftOnBreak == 1) {
          StatusInfo _stateInfo = StatusInfo.protected_on_break_24_combo;
          return ProtectionStateInfo(state: _state, stateInfo: _stateInfo);
        }

        StatusInfo _stateInfo = StatusInfo.protected_must_resume_combo;
        return ProtectionStateInfo(state: _state, stateInfo: _stateInfo);
      }
      //The user has not completed the pack of actives and cannot break.
      StatusInfo _stateInfo = StatusInfo.protected_combo;
      return ProtectionStateInfo(state: _state, stateInfo: _stateInfo);
    }
    //If the pill is a mini pill, then the state is unprotected.
    else if (widget.isMiniPill) {
      Status _state = Status.unprotected;

      // If an active pill was taken in the recent past, then only 24 hours
      // must pass before the user is protected
      if (lastWasActive &&
          widget.pressedPills[0].date.difference(DateTime.now()).inHours <=
              MINI_TIME_WINDOW) {
        StatusInfo _stateInfo = StatusInfo.unprotected_24_mini;
        return ProtectionStateInfo(state: _state, stateInfo: _stateInfo);
      }
      StatusInfo _stateInfo = StatusInfo.unprotected_max_mini;
      return ProtectionStateInfo(state: _state, stateInfo: _stateInfo);
    }
    //Check for late pills.
    // If the pill is in week 1 and has any late pills the state is unprotected
    if (activePillCount <= COMBO_EFFECTIVE_PILLS && latePills > 0) {
      Status _state = Status.unprotected;
      StatusInfo _stateInfo = StatusInfo.unprotected_X_combo;
      return ProtectionStateInfo(state: _state, stateInfo: _stateInfo);
    }
    // If the pill is in week 2 and has 1 max missed time the state is compromised
    else if (lastWasActive &&
        activePillCount >= expectedActiveDays &&
        (activePillCount < COMBO_EFFECTIVE_PILLS + WEEK_DAY_COUNT) &&
        latePills <= 1) {
      Status _state = Status.compromised;
      StatusInfo _stateInfo = StatusInfo.compromised_combo;
      return ProtectionStateInfo(state: _state, stateInfo: _stateInfo);
    }
    // If the pill is in week 3 or 4 and has 2 max missed time the state is compromised
    else if (lastWasActive &&
        activePillCount >= expectedActiveDays &&
        latePills <= 2) {
      Status _state = Status.compromised;
      StatusInfo _stateInfo = StatusInfo.compromised_combo;
      return ProtectionStateInfo(state: _state, stateInfo: _stateInfo);
    }
    Status _state = Status.unprotected;
    StatusInfo _stateInfo = StatusInfo.unprotected_X_combo;
    return ProtectionStateInfo(state: _state, stateInfo: _stateInfo);
  }

  int _getEffectiveTotalActiveDays() =>
      _getEffectivePackageWeeks() * 7 - widget.placeboDays;

  bool _isValidPill(DateTime currentDate, DateTime lastDate, int hours) =>
      _getHoursDifference(currentDate, lastDate) <= hours;

  int _getHoursDifference(DateTime currentDate, DateTime lastDate) {
    int hours = lastDate.difference(currentDate).inHours.abs();
    return hours;
  }

  String _getReasonString(StatusInfo _stateInfo) {
    switch (_stateInfo) {
      case StatusInfo.unprotected_max_mini:
        return sprintf(PROTECTED_IN_X_DAYS, ["two"]);
      case StatusInfo.unprotected_24_mini:
        return PROTECTED_IN_24_HOURS;
      case StatusInfo.protected_mini:
        return PROTECTED_ALL_CORRECT;
      case StatusInfo.unprotected_max_combo:
        return sprintf(PROTECTED_IN_X_DAYS, ["seven"]);
      case StatusInfo.unprotected_X_combo:
        //TODO This doesn't seem right for all cases.
        int days = COMBO_EFFECTIVE_PILLS -
            _getRecentFirstActiveDate().difference(DateTime.now()).inDays.abs();
        if (days > 1) {
          return sprintf(PROTECTED_IN_X_DAYS,
              [NumberWordsSpelling.toWord(days.toString(), "en_US")]);
        }
        return PROTECTED_IN_24_HOURS;
      case StatusInfo.compromised_combo:
        return COMPROMISED_REASON;
      case StatusInfo.protected_combo:
        return PROTECTED_ALL_CORRECT;
      case StatusInfo.protected_can_break_combo:
        return sprintf(PROTECTED_BREAK_AVAILABLE, [
          NumberWordsSpelling.toWord(widget.placeboDays.toString(), "en_US")
        ]);
      case StatusInfo.protected_on_break_combo:
        int days = widget.placeboDays -
            _getLastActiveDate().difference(DateTime.now()).inDays.abs();
        return sprintf(PROTECTED_MULTIPLE_DAYS_REMAINING,
            [NumberWordsSpelling.toWord(days.toString(), "en_US")]);
      case StatusInfo.protected_on_break_24_combo:
        return PROTECTED_24_HOURS_REMAINING;
      case StatusInfo.protected_must_resume_combo:
        return PROTECTED_NO_TIME_REMAINING;
    }
    return "";
  }

  String _getStateString(Status _state) {
    switch (_state) {
      case Status.protected:
        return "Protected";
        break;
      case Status.compromised:
        return "Compromised";
        break;
      case Status.unprotected:
        return "Unprotected";
        break;
    }
    return "Unknown";
  }

  TextStyle _getTextStyle(Status _state) {
    switch (_state) {
      case Status.protected:
        return TextStyle(color: Colors.green, fontWeight: FontWeight.bold);
        break;
      case Status.compromised:
        return TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold);
        break;
      case Status.unprotected:
        return TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
        break;
    }
    return null;
  }

  DateTime _getLastActiveDate() {
    for (PressedPill pill in widget.pressedPills) {
      if (pill.active) {
        return pill.date;
      }
    }
    return null;
  }

  DateTime _getRecentFirstActiveDate() {
    DateTime activeDate;
    bool foundActive = false;
    for (PressedPill pill in widget.pressedPills) {
      if (pill.active) {
        foundActive = true;
        activeDate = pill.date;
      }

      if (foundActive && !pill.active) {
        return activeDate;
      }
    }
    return activeDate;
  }

  int _getCurrentActivePillCount(int hourWindow, bool countInvalid) {
    int activePillCount = 0;

    bool foundFirstActive = false;

    //Only count till an inactive pill or invalid pill is encountered.
    if (!countInvalid) {
      DateTime lastPillTime;
      for (PressedPill pill in widget.pressedPills) {
        //Count the active pills
        if (pill.active &&
            lastPillTime != null &&
            _isValidPill(pill.date, lastPillTime, hourWindow)) {
          // Count the first time this is called twice, since it requires
          // 2 valid pills the first time and only one additional valid
          // pills all the next.
          if (!foundFirstActive) {
            foundFirstActive = true;
            activePillCount++;
          }
          activePillCount++;
        }
        // If we have already found actives and the pill is no longer active,
        // Or the time elapsed was too great, break.
        if (foundFirstActive &&
            (!pill.active ||
                (lastPillTime != null &&
                    !_isValidPill(pill.date, lastPillTime, hourWindow)))) {
          break;
        }
        lastPillTime = pill.date;
      }
    }
    //Count till an inactive pill is encountered.
    else {
      for (PressedPill pill in widget.pressedPills) {
        if (pill.active) {
          activePillCount++;
          foundFirstActive = true;
        }
        if (!pill.active && foundFirstActive) {
          break;
        }
      }
    }

    return activePillCount;
  }
}
