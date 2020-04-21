import 'package:flutter/material.dart';

class Pill extends StatefulWidget {
  Pill({Key key, this.isActive, this.isPressed}) : super(key: key);

  final bool isActive;
  final bool isPressed;

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
                tooltip: 'Tooltip',
                onPressed: () {
                  setState(() {
                    _pressed = !_pressed;
                  });
                },
                color: color,
                iconSize: size,
                splashColor: Colors.black54)));
  }
}
