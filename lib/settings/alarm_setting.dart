import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:pill_reminder/settings/settings_widget.dart';
import 'package:scheduler/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_defaults.dart' as AppDefaults;
import 'settings_constants.dart' as SettingsConstants;

class AlarmSetting extends SettingsWidget {
  AlarmSetting(
      {Key key,
      String displayName,
      TimeOfDay initialValue,
      String storageName,
      Function loadData})
      : super(
            key: key,
            displayName: displayName,
            initialValue: initialValue,
            storageName: storageName,
            loadData: loadData);

  @override
  SettingsWidgetState createState() => _AlarmSettingState();
}

class _AlarmSettingState extends SettingsWidgetState<AlarmSetting, TimeOfDay> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.displayName),
      trailing: Text(currentValue.format(context)),
      onTap: () {
        _showUpdateDialog(context);
      },
    );
  }

  _showUpdateDialog(BuildContext context) {
    DateTime _dateTime;

    Widget timePicker = TimePickerSpinner(
      is24HourMode: false,
      normalTextStyle: TextStyle(
          color: AppDefaults.getCanvasColor(),
          fontSize: AppDefaults.getPrimaryFontSize()),
      highlightedTextStyle: TextStyle(
          color: AppDefaults.getPrimaryTextColor(),
          fontSize: AppDefaults.getPrimaryFontSize()),
      onTimeChange: (time) {
        _dateTime = time;
      },
    );

    Widget decoratedBox = DecoratedBox(
        child: timePicker,
        decoration: BoxDecoration(
            border: Border.all(
          color: AppDefaults.getCanvasColor(),
          width: 2,
        )));

    Function onSavePressed = () {
      setState(() {
        currentValue = TimeOfDay.fromDateTime(_dateTime);
      });
      savePreference(currentValue);
      Scheduler.cancelNotification();
      Scheduler.scheduleNotification(currentValue, "Pill Reminder", "Take your pill.");
      Navigator.of(context).pop();
    };

    showUpdateDialog(context, decoratedBox, onSavePressed);
  }

  @override
  savePreference(newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(SettingsConstants.HOURS_ALARM_TIME, currentValue.hour);
    prefs.setInt(SettingsConstants.MINUTES_ALARM_TIME, currentValue.minute);
  }
}
