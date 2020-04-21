import 'package:flutter/material.dart';
import 'pill.dart';

class PillPackage extends StatefulWidget {
  PillPackage({Key key, this.totalWeeks, this.placeboDays}) : super(key: key);

  final int totalWeeks;
  final int placeboDays;

  @override
  _PillPackageState createState() => _PillPackageState();
}

class _PillPackageState extends State<PillPackage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisCount: 7,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          childAspectRatio: 1,
          children: getPills()),
    );
  }

  List<Widget> getPills() {
    int partialWeekActivePills = 7 - widget.placeboDays;
    int activePills =
        widget.totalWeeks * 7 - widget.placeboDays - partialWeekActivePills;

    //Because the grid fills from top to bottom, the last active pills
    // must be put before the last active pills if there are any partial week active pills.

    List<Widget> pills = List<Widget>();
    for (int i = 0; i < activePills; i++) {
      pills.add(new Pill(isActive: true, isPressed: false));
    }

    for (int i = 0; i < widget.placeboDays; i++) {
      pills.add(new Pill(isActive: false, isPressed: false));
    }

    for (int i = 0; i < partialWeekActivePills; i++) {
      pills.add(new Pill(isActive: true, isPressed: false));
    }

    return pills;
  }
}
