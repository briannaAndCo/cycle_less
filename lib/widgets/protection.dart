import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:number_to_words_spelling/number_to_words_spelling.dart';
import 'package:cycleless/model/pill_package_model.dart';
import 'package:sprintf/sprintf.dart';
import '../data/pressed_pill.dart';
import 'protection_status_info.dart';

class Protection extends StatelessWidget {
  Protection(
      {Key key,
      this.pillPackageModel,
      this.totalWeeks,
      this.placeboDays,
      this.isMiniPill})
      : super(key: key);

  final PillPackageModel pillPackageModel;
  final int totalWeeks;
  final int placeboDays;
  final bool isMiniPill;

  @override
  Widget build(BuildContext context) => Card(
      child: Observer(
          builder: (_) => Container(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Column(
                children: pillPackageModel.loadedPills == null
                    ? _getUnknownState()
                    : _getCurrentState(),
              ))));

  List<Widget> _getCurrentState() {
    ProtectionStatusInfo info = _getProtectionState();
    return [
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
  }

  List<Widget> _getUnknownState() {
    return [
      Text("Unknown"),
      Text(
        "Could not load past pills.",
        textAlign: TextAlign.center,
      ),
    ];
  }

  ProtectionStatusInfo _calculateProtectionStatusInfoComboPill() {
    if (_isProtectedCurrentPack()) {
      return ProtectionStatusInfo(
          state: Status.protected, stateInfo: _getStatusInfoForCurrentPack());
    }
    if (_isActiveAndCurrentPackInvalid()) {
      return _getStatusForLastPack();
    }

    return ProtectionStatusInfo(
        state: Status.unprotected, stateInfo: StatusInfo.unprotected_X_combo);
  }

  ProtectionStatusInfo _calculateProtectionStatusInfoMiniPill() {
    DateTime now = DateTime.now();
    DateTime lastPillTime = pillPackageModel.loadedPills[0].date;

    //Get the state of the current pills taken to date.
    int currentValidActives = _countPerfectUseActives(MINI_TIME_WINDOW, 0);
    bool lastPillValid =
        _getHoursDifference(now, lastPillTime) < MINI_TIME_WINDOW;

    // If the last pill was not valid or the current valid pill count is
    // more than a single day away from being active, then the state
    // is maximum unprotection
    if (!lastPillValid || currentValidActives < MINI_EFFECTIVE_PILLS - 1) {
      Status _status = Status.unprotected;
      StatusInfo _statusInfo = StatusInfo.unprotected_max_mini;
      return ProtectionStatusInfo(state: _status, stateInfo: _statusInfo);
    }
    // Else if the last pill was valid and the current valid actives are
    // only one day away from becoming effective then the state is unprotected
    // for 24 more hours
    else if (lastPillValid && currentValidActives == MINI_EFFECTIVE_PILLS - 1) {
      Status _status = Status.unprotected;
      StatusInfo _statusInfo = StatusInfo.unprotected_24_mini;
      return ProtectionStatusInfo(state: _status, stateInfo: _statusInfo);
    }
    //Else the mini pill is protected.
    Status _status = Status.protected;
    StatusInfo _statusInfo = StatusInfo.protected_mini;
    return ProtectionStatusInfo(state: _status, stateInfo: _statusInfo);
  }

  int _countLastGapDaysBetweenActives() {
    PressedPill lastActivePill;
    for (PressedPill pill in pillPackageModel.loadedPills) {
      if (pill.active && lastActivePill != null) {
        if (!_isValidPill(pill.date, lastActivePill.date, COMBO_TIME_WINDOW)) {
          return pill.date.difference(lastActivePill.date).inDays.abs();
        }
      }
      if (pill.active) {
        lastActivePill = pill;
      }
    }

    return 0;
  }

  int _countPerfectUseActives(int hourWindow, int pillListStart) {
    int activePillCount = 0;
    bool foundFirstActive = false;
    DateTime lastPillTime;

    for (int i = 0; i < pillPackageModel.loadedPills.length; i++) {
      //Don't bother looking at the pills before the starting point.
      if (i < pillListStart) continue;

      PressedPill pill = pillPackageModel.loadedPills[i];

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
      if (pill.active) {
        lastPillTime = pill.date;
      }
    }
    return activePillCount;
  }

  int _countPreviousPerfectUseActives() {
    PressedPill lastActivePill;
    for (int i = 0; i < pillPackageModel.loadedPills.length; i++) {
      PressedPill pill = pillPackageModel.loadedPills[i];
      if (pill.active && lastActivePill != null) {
        //If a gap between actives was found, count all valid actives after the gap.
        if (!_isValidPill(pill.date, lastActivePill.date, COMBO_TIME_WINDOW)) {
          return _countPerfectUseActives(COMBO_TIME_WINDOW, i);
        }
      }
      if (pill.active) {
        lastActivePill = pill;
      }
    }

    return 0;
  }

  int _getEffectivePackageDays() => _getEffectivePackageWeeks() * 7;

  int _getEffectivePackageWeeks() {
    return totalWeeks > COMBO_STANDARD_PILL_PACKAGE
        ? COMBO_STANDARD_PILL_PACKAGE
        : totalWeeks;
  }

  int _getEffectiveTotalActiveDays() =>
      _getEffectivePackageDays() - placeboDays;

  int _getHoursDifference(DateTime currentDate, DateTime lastDate) {
    int hours = lastDate.difference(currentDate).inHours.abs();
    return hours;
  }

  DateTime _getLastActiveDate() {
    for (PressedPill pill in pillPackageModel.loadedPills) {
      if (pill.active) {
        return pill.date;
      }
    }
    return null;
  }

  ProtectionStatusInfo _getProtectionState() {
    // If the pressed pills have not been loaded or there are no pressed pills
    // the user is not protected
    if (pillPackageModel.loadedPills == null ||
        pillPackageModel.loadedPills.length == 0) {
      Status _status = Status.unprotected;
      StatusInfo _statusInfo = isMiniPill
          ? StatusInfo.unprotected_max_mini
          : StatusInfo.unprotected_X_combo;
      return ProtectionStatusInfo(state: _status, stateInfo: _statusInfo);
    }

    if (isMiniPill) {
      return _calculateProtectionStatusInfoMiniPill();
    } else {
      return _calculateProtectionStatusInfoComboPill();
    }
  }

  String _getReasonString(StatusInfo _statusInfo) {
    String returnString;
    switch (_statusInfo) {
      case StatusInfo.unprotected_max_mini:
        returnString = sprintf(PROTECTED_IN_X_DAYS, ["two"]);
        break;
      case StatusInfo.unprotected_24_mini:
        returnString = PROTECTED_IN_24_HOURS;
        break;
      case StatusInfo.protected_mini:
        returnString = PROTECTED_MINI;
        break;
      case StatusInfo.unprotected_X_combo:
        if (_isInActiveWindowCombo()) {
          int days = COMBO_EFFECTIVE_PILLS -
              _countPerfectUseActives(COMBO_TIME_WINDOW, 0);

          print("days $days");
          if (days > 1) {
            returnString = sprintf(PROTECTED_IN_X_DAYS,
                [NumberWordsSpelling.toWord(days.toString(), "en_US")]);
          } else if (days <= 1) {
            returnString = PROTECTED_IN_24_HOURS;
          }
        } else {
          returnString = sprintf(PROTECTED_IN_X_DAYS, ["seven"]);
        }
        break;
      case StatusInfo.compromised_combo:
        returnString = COMPROMISED_REASON;
        break;
      case StatusInfo.protected_cannot_break_combo:
        returnString = PROTECTED_COMBO;
        break;
      case StatusInfo.protected_can_break_combo:
        returnString = sprintf(PROTECTED_BREAK_AVAILABLE,
            [NumberWordsSpelling.toWord(placeboDays.toString(), "en_US")]);
        break;
      case StatusInfo.protected_on_break_combo:
        int days = placeboDays -
            _getLastActiveDate().difference(DateTime.now()).inDays.abs();
        returnString = sprintf(PROTECTED_MULTIPLE_DAYS_REMAINING,
            [NumberWordsSpelling.toWord(days.toString(), "en_US")]);
        break;
      case StatusInfo.protected_on_break_24_combo:
        returnString = PROTECTED_24_HOURS_REMAINING;
        break;
      case StatusInfo.protected_must_resume_combo:
        returnString = PROTECTED_NO_TIME_REMAINING;
    }
    print("return string $returnString");

    return returnString ?? "";
  }

  String _getStateString(Status _status) {
    switch (_status) {
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

  ProtectionStatusInfo _getStatusForLastPack() {
    if (_isValidLastPack()) {
      return ProtectionStatusInfo(
          state: Status.protected,
          stateInfo: StatusInfo.protected_cannot_break_combo);
    } else if (_isCompromisedLastPack()) {
      return ProtectionStatusInfo(
          state: Status.compromised, stateInfo: StatusInfo.compromised_combo);
    }
    return ProtectionStatusInfo(
        state: Status.unprotected, stateInfo: StatusInfo.unprotected_X_combo);
  }

  StatusInfo _getStatusInfoForCurrentPack() {
    int perfectUseActives = _countPerfectUseActives(COMBO_TIME_WINDOW, 0);

    // If perfect use is less than the total number of active days required to
    // break then a break may not be taken.
    if (perfectUseActives < _getEffectiveTotalActiveDays()) {
      return StatusInfo.protected_cannot_break_combo;
    }

    bool lastWasActive = pillPackageModel.loadedPills[0].active;

    //The last pill taken in 24 hours was active then the user may break.
    if (lastWasActive &&
        _getLastActiveDate().difference(DateTime.now()).inHours.abs() <=
            COMBO_TIME_WINDOW) {
      return StatusInfo.protected_can_break_combo;
    }
    // Else if either the last pill was not active (placebo) or the user
    // difference time between the last actives was greater than the
    // max time window allowed the user is considered on break
    int daysLeftOnBreak = placeboDays -
        _getLastActiveDate().difference(DateTime.now()).inDays.abs();

    if (daysLeftOnBreak >= 2) {
      return StatusInfo.protected_on_break_combo;
    } else if (daysLeftOnBreak == 1) {
      return StatusInfo.protected_on_break_24_combo;
    }

    return StatusInfo.protected_must_resume_combo;
  }

  TextStyle _getTextStyle(Status _status) {
    switch (_status) {
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

  bool _isActiveAndCurrentPackInvalid() {
    int perfectUseActives = _countPerfectUseActives(COMBO_TIME_WINDOW, 0);
    return (perfectUseActives < COMBO_EFFECTIVE_PILLS &&
        _getLastActiveDate().difference(DateTime.now()).inHours.abs() <=
            COMBO_TIME_WINDOW);
  }

  bool _isCompromisedLastPack() {
    int activePillCount = 0;
    int latePillCount = 0;
    PressedPill lastActivePill;
    for (int i = 0;
        i < _getEffectiveTotalActiveDays() &&
            i < pillPackageModel.loadedPills.length;
        i++) {
      PressedPill pill = pillPackageModel.loadedPills[i];

      if (lastActivePill != null &&
          !_isValidPill(pill.date, lastActivePill.date, COMBO_TIME_WINDOW)) {
        latePillCount++;
      }

      if (pill.active) {
        activePillCount++;
        lastActivePill = pill;
      }
    }

    int weekOneDays = COMBO_EFFECTIVE_PILLS;
    int weekTwoDays = weekOneDays + 7;

    // If there is one late pill and the user is in week 2
    // or if there are two late pills and the user is in week 3 or 4
    // the state is compromised
    return latePillCount <= 1 && activePillCount >= weekOneDays ||
        latePillCount <= 2 && activePillCount >= weekTwoDays;
  }

  bool _isInActiveWindowCombo() {
    DateTime _lastActiveDate = _getLastActiveDate();
    if (_lastActiveDate == null) {
      return false;
    }

    return _getHoursDifference(_lastActiveDate, DateTime.now()) <=
        COMBO_TIME_WINDOW;
  }

  bool _isProtectedCurrentPack() {
    DateTime _lastActiveDate = _getLastActiveDate();
    if (_lastActiveDate == null) {
      return false;
    }

    int perfectUseActives = _countPerfectUseActives(COMBO_TIME_WINDOW, 0);
    DateTime currentTime = DateTime.now();

    return (perfectUseActives >= COMBO_EFFECTIVE_PILLS &&
            _getHoursDifference(_lastActiveDate, currentTime) <=
                COMBO_TIME_WINDOW) ||
        perfectUseActives >= _getEffectiveTotalActiveDays() &&
            _getHoursDifference(_lastActiveDate, currentTime) <=
                (placeboDays * 24 + COMBO_TIME_WINDOW);
  }

  bool _isValidLastPack() {
    int gapDays = _countLastGapDaysBetweenActives();
    int allowedTimeSlipDays = (COMBO_TIME_WINDOW / 24).floor();
    return gapDays <= placeboDays + allowedTimeSlipDays &&
        _countPreviousPerfectUseActives() >= _getEffectiveTotalActiveDays();
  }

  bool _isValidPill(DateTime currentDate, DateTime lastDate, int hours) =>
      _getHoursDifference(currentDate, lastDate) <= hours;
}
