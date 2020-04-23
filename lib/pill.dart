import 'package:flutter/material.dart';
import 'database_defaults.dart' as DatabaseDefaults;
import 'data_models/pressed_pill.dart';

class Pill extends StatefulWidget {
  Pill(
      {Key key,
      this.id,
      this.day,
      this.isActive,
      this.isPressed,
      this.refreshDataCall})
      : super(key: key);

  final int id;
  final int day;
  final bool isActive;
  final bool isPressed;
  final Function refreshDataCall;

  @override
  _PillState createState() => _PillState();
}

class _PillState extends State<Pill> {
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _pressed = widget.isPressed;
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
                  setState(() {
                    _pressed = !_pressed;
                    if (_pressed) {
                      savePress();
                    } else {
                      deletePress();
                    }
                  });
                },
                color: color,
                iconSize: size,
                splashColor: Colors.black54)));
  }

  void deletePress() {
    DatabaseDefaults.deletePressedPill(widget.id);
    _updatePillPackageData();
  }

  void savePress() {
    PressedPill pressedPill = PressedPill(
        id: widget.id,
        day: widget.day,
        date: DateTime.now(),
        active: widget.isActive);
    DatabaseDefaults.insertPressedPill(pressedPill);

    _updatePillPackageData();
  }

  void _updatePillPackageData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      widget.refreshDataCall();
    });
  }
}
