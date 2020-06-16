import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/scheduler.dart';
import '../data/database_defaults.dart' as DatabaseDefaults;
import '../data/pressed_pill.dart';
import '../app_defaults.dart' as AppDefaults;

class Pill extends StatefulWidget {
  Pill(
      {Key key,
      this.id,
      this.day,
      this.date,
      this.isActive,
      this.isPressed,
      this.alarmTime,
      this.refreshDataCall})
      : super(key: key);

  final int id;
  final int day;
  final DateTime date;
  final bool isActive;
  final bool isPressed;
  final TimeOfDay alarmTime;
  final Function refreshDataCall;

  @override
  _PillState createState() => _PillState();
}

class _PillState extends State<Pill> {
  bool _pressed = false;
  DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _pressed = widget.isPressed;
      _currentDate = widget.date;
    });
  }

  @override
  Widget build(BuildContext context) {
    IconData icon = _pressed ? Icons.brightness_1 : Icons.fiber_manual_record;

    Color color = _pressed
        ? Colors.grey
        : (widget.isActive ? Colors.white70 : Colors.brown[900]);
    double size = _pressed ? 32 : (widget.isActive ? 30 : 34);

    return Container(
        //  color: Colors.pink,
        child: new Material(
            type: MaterialType.transparency,
            child: IconButton(
                icon: Icon(icon),
                tooltip: widget.day.toString(),
                onPressed: () {
                  showPressDialog(context);
                },
                color: color,
                iconSize: size,
                splashColor: Colors.black54)));
  }

  showPressDialog(BuildContext context) {
    DateTime localDate = _currentDate;

    Widget widget = Container(
      height: MediaQuery.of(context).copyWith().size.height / 4,
      child: DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(
            color: AppDefaults.getCanvasColor(),
            width: 2,
          )),
          child: CupertinoDatePicker(
            initialDateTime: _currentDate?? DateTime.now(),
            onDateTimeChanged: (newDate) {
              localDate = newDate;
            },
            use24hFormat: false,
            maximumDate: DateTime.now(),
            minuteInterval: 1,
            mode: CupertinoDatePickerMode.dateAndTime,
          )),
    );

    // set up the buttons
    Widget _saveOrUpdateButton = FlatButton(
      child: Text(localDate == null ? "Save" : "Update"),
      onPressed: () {
        saveOrUpdatePress(localDate);
      },
    );

    Widget _deleteButton = FlatButton(
      child: Text("Delete"),
      onPressed: deletePress,
    );

    Widget _cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

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

  void deletePress() {
    setState(() {
      _pressed = false;
      _currentDate = null;
    });
    DatabaseDefaults.deletePressedPill(widget.id);
    Navigator.of(context).pop();
    _updatePillPackageData();

    //Reschedule the next notifications, to make sure they aren't missed
    //TODO: Centralize these text strings
    Scheduler.scheduleNotification(widget.alarmTime, "Pill Reminder", "Take your pill.");
  }

  void saveOrUpdatePress(DateTime dateTime) {
    setState(() {
      _pressed = true;
      _currentDate = dateTime;
    });
    PressedPill pressedPill = PressedPill(
        id: widget.id,
        day: widget.day,
        date: dateTime,
        active: widget.isActive);
    DatabaseDefaults.insertOrUpdatePressedPill(pressedPill);
    Navigator.of(context).pop();
    _updatePillPackageData();

    double timeDifference =  convert(TimeOfDay.fromDateTime(dateTime)) - convert(widget.alarmTime);

    // If this is less than 12 hours ahead or less than .5 hours after,
    // cancel the next scheduled notification.
    if(timeDifference >= -12 || timeDifference < .5)
      {
        Scheduler.cancelNextNotification(widget.alarmTime);
      }
  }

  void _updatePillPackageData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      widget.refreshDataCall();
    });
  }

  double convert(TimeOfDay myTime) => myTime.hour + myTime.minute/60.0;
}
