import 'package:flutter/material.dart';
import '../data/database_defaults.dart' as DatabaseDefaults;
import '../data/pressed_pill.dart';

class Protection extends StatefulWidget {
  Protection({Key key, this.pressedPills, this.totalWeeks, this.placeboDays, this.isMiniPill, this.refreshDataCall})
      : super(key: key);

  final List<PressedPill> pressedPills;
  final int totalWeeks;
  final int placeboDays;
  final bool isMiniPill;
  final Function refreshDataCall;

  @override
  _ProtectionState createState() => _ProtectionState();
}

class _ProtectionState extends State<Protection> {
  @override
  Widget build(BuildContext context) {
          List<Widget> children = new List();

          if (widget.pressedPills != null) {
            children = [Text("Unprotected"), Text("Due to <Reason>")];
          } else {
            children = [Text("Unknown"), Text("Could not load past pills.")];
          }

          return Card(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                  child: Column(
                    children: children,
                  )));
  }
}
