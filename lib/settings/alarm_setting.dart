import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cycleless/settings/settings_widget.dart';
import 'package:scheduler/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_defaults.dart' as AppDefaults;
import 'settings_constants.dart' as SettingsConstants;
import '../model/settings_model.dart';

class AlarmSetting extends SettingsWidget {
  AlarmSetting({Key key, SettingsModel settingsModel})
      : super(
            key: key,
            displayName: "Alarm",
            settingsModel: settingsModel,
            storageName: "");

  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) => ListTile(
              title: Text(displayName),
              trailing: Text(settingsModel.alarmTime.format(context)),
              onTap: () {
                _showUpdateDialog(context);
              },
            ));

  _showUpdateDialog(BuildContext context) {
    DateTime _dateTime;

    TimeOfDay timeOfDay = settingsModel.alarmTime ?? null;

    double width = MediaQuery.of(context).copyWith().size.width;
    Widget timePicker = Container(
        width: width - width / 20,
        height: MediaQuery.of(context).copyWith().size.height / 4,
        child: CupertinoDatePicker(
          initialDateTime: timeOfDay != null
              ? DateTime(1969, 1, 1, timeOfDay.hour, timeOfDay.minute)
              : DateTime.now(),
          onDateTimeChanged: (time) {
            _dateTime = time;
          },
          use24hFormat: false,
          minuteInterval: 1,
          mode: CupertinoDatePickerMode.time,
        ));

    Widget decoratedBox = DecoratedBox(
        child: timePicker,
        decoration: BoxDecoration(
            border: Border.all(
          color: AppDefaults.getCanvasColor(),
          width: 2,
        )));

    Function onSavePressed = () {
      TimeOfDay timeOfDay = TimeOfDay.fromDateTime(_dateTime);
      settingsModel.setAlarmTime(timeOfDay);
      savePreference(timeOfDay);
      Scheduler.scheduleNotification(
          timeOfDay, "Pill Reminder", "Take your pill.");
      Navigator.of(context).pop();
    };

    showUpdateDialog(context, decoratedBox, onSavePressed);
  }

  @override
  savePreference(newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(SettingsConstants.HOURS_ALARM_TIME, newValue.hour);
    prefs.setInt(SettingsConstants.MINUTES_ALARM_TIME, newValue.minute);
  }
}
