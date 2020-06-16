import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

    TimeOfDay timeOfDay = currentValue?? null;

    double width = MediaQuery.of(context).copyWith().size.width;
    Widget timePicker = Container(
        width:  width - width/20,
        height: MediaQuery.of(context).copyWith().size.height/4,
        child: CupertinoDatePicker(
          initialDateTime: timeOfDay != null ? DateTime(1969, 1, 1, timeOfDay.hour, timeOfDay.minute) : DateTime.now(),
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
