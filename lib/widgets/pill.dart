import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pill_reminder/model/pill_model.dart';
import 'package:scheduler/scheduler.dart';
import '../data/database_defaults.dart' as DatabaseDefaults;
import '../data/pressed_pill.dart';
import '../app_defaults.dart' as AppDefaults;

class Pill extends StatelessWidget {
  Pill(
      {Key key,
      this.id,
      this.day,
      this.isActive,
      this.pillModel,
      this.alarmTime,
      this.refreshDataCall})
      : super(key: key);

  final int id;
  final int day;
  final bool isActive;
  final PillModel pillModel;
  final TimeOfDay alarmTime;
  final Function refreshDataCall;

  @override
  Widget build(BuildContext context) {

    return Observer(
        builder: (_) => Container(
        //  color: Colors.pink,
        child: new Material(
            type: MaterialType.transparency,
            child: IconButton(
                icon: Icon(_getIcon()),
                tooltip: day.toString(),
                onPressed: () {
                  showPressDialog(context);
                },
                color: _getColor(),
                iconSize: _getSize(),
                splashColor: Colors.black54))));
  }

  double _getSize() => pillModel.isPressed ? 32 : (isActive ? 30 : 34);

  Color _getColor() {
    return pillModel.isPressed
      ? Colors.grey
      : (isActive ? Colors.white70 : Colors.brown[900]);
  }

  IconData _getIcon() => pillModel.isPressed ? Icons.brightness_1 : Icons.fiber_manual_record;

  showPressDialog(BuildContext context) {
    DateTime localDateTime = this.pillModel.currentDate ?? DateTime.now();

    Widget widget = Container(
      height: MediaQuery.of(context).copyWith().size.height / 4,
      child: DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(
            color: AppDefaults.getCanvasColor(),
            width: 2,
          )),
          child: CupertinoDatePicker(
            initialDateTime: localDateTime,
            onDateTimeChanged: (newDate) {
              localDateTime = newDate;
            },
            use24hFormat: false,
            maximumDate: DateTime.now(),
            minuteInterval: 1,
            mode: CupertinoDatePickerMode.dateAndTime,
          )),
    );

    // set up the buttons
    Widget _saveOrUpdateButton = FlatButton(
      child: Text(this.pillModel.currentDate == null ? "Save" : "Update"),
      onPressed: () {
        saveOrUpdatePress(context, localDateTime);
      },
    );

    Widget _deleteButton = FlatButton(
      child: Text("Delete"),
      onPressed: () {
        deletePress(context);
      },
    );

    Widget _cancelButton = FlatButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        });

    // set up the dialog to update the number
    AlertDialog alert = AlertDialog(
      title: Text("Set Pill Taken Time"),
      content: widget,
      backgroundColor: Colors.black87,
      actions: [_cancelButton, _saveOrUpdateButton, _deleteButton],
    );

    //show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void deletePress(BuildContext context) {
    pillModel.setPressed(false);
    pillModel.setCurrentDate(null);

    DatabaseDefaults.deletePressedPill(id);
    Navigator.of(context).pop();

    //Reschedule the next notifications, to make sure they aren't missed
    //TODO: Centralize these text strings
    Scheduler.scheduleNotification(
        alarmTime, "Pill Reminder", "Take your pill.");

  //  _updatePillPackageData();
  }

  void saveOrUpdatePress(BuildContext context, DateTime dateTime) {
    pillModel.setPressed(true);
    pillModel.setCurrentDate(dateTime);

    PressedPill pressedPill =
        PressedPill(id: id, day: day, date: dateTime, active: isActive);
    DatabaseDefaults.insertOrUpdatePressedPill(pressedPill);
    Navigator.of(context).pop();

    double timeDifference =
        convert(TimeOfDay.fromDateTime(dateTime)) - convert(alarmTime);

    // If this is less than 12 hours ahead or less than .5 hours after,
    // cancel the next scheduled notification.
    if (timeDifference >= -12 || timeDifference < .5) {
      Scheduler.cancelNextNotification(alarmTime);
    }

   // _updatePillPackageData();
  }

  void _updatePillPackageData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      refreshDataCall();
    });
  }

  double convert(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
}
