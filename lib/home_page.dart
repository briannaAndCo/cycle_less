import 'package:flutter/material.dart';
import 'package:pill_reminder/settings/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_defaults.dart' as AppDefaults;
import 'data/database_defaults.dart' as DatabaseDefaults;
import 'data/pressed_pill.dart';
import 'settings/settings_constants.dart' as SettingsDefaults;
import 'settings/settings_page.dart';
import 'widgets/pill_package.dart';
import 'widgets/protection.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PressedPill> _pressedPills;
  bool _loadedData = false;
  int _pillPackageWeeks;
  int _placeboDays;
  bool _miniPill;
  TimeOfDay _alarmTime;

  @override
  void initState() {
    super.initState();
    DatabaseDefaults.createDatabase();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AppDefaults.showLoading(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: _loadData(),
      builder: (context, AsyncSnapshot<bool> loadedData) {
        Widget body;

        if (loadedData.hasData) {
          if (!_loadedData) {
            AppDefaults.hideLoading(context);
            _loadedData = true;
          }

          body = Container(
              child: Column(children: [
            Expanded(
              child: PillPackage(
                pressedPills: _pressedPills,
                totalWeeks: _pillPackageWeeks,
                placeboDays: _placeboDays,
                alarmTime: _alarmTime,
                refreshDataCall: _updateData,
              ),
            ),
            SizedBox(height: 20),
            Protection(
              pressedPills: _pressedPills,
              totalWeeks: _pillPackageWeeks,
              placeboDays: _placeboDays,
              isMiniPill: false,
            ),
            SizedBox(height: 10),
          ]));
        } else {
          body = Container();
        }

        return Scaffold(
            appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.

                title: Text(widget.title),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage()),
                        ).whenComplete(_updateData);
                      })
                ]),
            body: body);
      },
    );
  }

  _updateData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _pressedPills = null;
        _loadData();
      });
    });
  }

  Future<bool> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _setSettingsValues(prefs);
    //Only bother loading the 2 last packages since that is the max required to maintain protection
    int maxRetrieve = _pillPackageWeeks * 7 * 2;
    _pressedPills = await DatabaseDefaults.retrievePressedPills(maxRetrieve);
    return true;
  }

  void _setSettingsValues(_preferences) {
    _pillPackageWeeks =
        (_preferences.getInt(SettingsDefaults.PILL_PACKAGE_WEEKS) ?? 4);
    _placeboDays = (_preferences.getInt(SettingsDefaults.PLACEBO_DAYS) ?? 7);
    _miniPill = (_preferences.getBool(SettingsDefaults.MINI_PILL) ?? false);
    int hours = (_preferences.getInt(SettingsDefaults.HOURS_ALARM_TIME) ?? 12);
    int minutes =
        (_preferences.getInt(SettingsDefaults.MINUTES_ALARM_TIME) ?? 0);
    _alarmTime = TimeOfDay(hour: hours, minute: minutes);
  }
}
