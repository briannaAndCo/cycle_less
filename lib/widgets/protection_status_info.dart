
enum Status { protected, compromised, unprotected }
enum StatusInfo {
  unprotected_max_mini,
  unprotected_24_mini,
  protected_mini,
  unprotected_X_combo,
  compromised_combo,
  protected_cannot_break_combo,
  protected_can_break_combo,
  protected_on_break_combo,
  protected_on_break_24_combo,
  protected_must_resume_combo
}

class ProtectionStatusInfo {
  ProtectionStatusInfo({this.state, this.stateInfo});

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
const String PROTECTED_MINI = "All pills have been taken correctly.";
const String PROTECTED_COMBO = "Continue active pills to maintain protection.";
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
