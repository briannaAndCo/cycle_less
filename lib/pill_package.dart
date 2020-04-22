import 'package:flutter/material.dart';
import 'package:pill_reminder/data_models/pressed_pill.dart';
import 'pill.dart';
import 'database_defaults.dart' as DatabaseDefaults;

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
    return new FutureBuilder(
        future: _loadPressedPills(),
        builder: (context, AsyncSnapshot<List<PressedPill>> pressedPills) {
          Widget body;

          if (pressedPills.hasData) {
            body = GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisCount: 7,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                childAspectRatio: 1,
                children: getPills(pressedPills.data));
          } else {
            body = Container();
          }

          return Center(
            child: body,
          );
        });
  }

  List<Widget> getPills(pressedPills) {
    int partialWeekActivePills = 7 - widget.placeboDays;
    int activePills =
        widget.totalWeeks * 7 - widget.placeboDays - partialWeekActivePills;
    int day = 7;
    int column = 1;



    // Because the package is a grid that fills from top to bottom,
    // The first day in the grid is a 7. This is decreased until day 0,
    // then the next columns last day is calculated
    void _calculateDay() {
      day--;
      if (day % 7 == 0) {
        day = column * 7 + 7;
        column++;
      }
    }

    for(PressedPill pill in pressedPills)
      {
        print(pill);
      }

    //Because the grid fills from top to bottom, the last active pills
    // must be put before the last active pills if there are any partial week active pills.
    List<Widget> pills = List<Widget>();
    for (int i = 0; i < activePills; i++) {
      pills.add(new Pill(id: null, day: day, isActive: true, isPressed: false));

      _calculateDay();
    }

    for (int i = 0; i < widget.placeboDays; i++) {
      pills.add(new Pill(id:null, day: day, isActive: false, isPressed: false));
      _calculateDay();
    }

    for (int i = 0; i < partialWeekActivePills; i++) {
      pills.add(new Pill(id: null, day: day, isActive: true, isPressed: false));
      _calculateDay();
    }

    return pills;
  }

  Future<List<PressedPill>> _loadPressedPills() async {
    List<PressedPill> pills = await DatabaseDefaults.retrievePressedPills();
    return pills;
  }
}
