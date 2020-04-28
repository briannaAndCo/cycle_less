import 'package:flutter/material.dart';
import 'package:pill_reminder/settings/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/pill_package.dart';
import 'widgets/protection.dart';
import 'settings/settings_page.dart';
import 'app_defaults.dart' as AppDefaults;
import 'settings/settings_constants.dart' as SettingsDefaults;
import 'data/database_defaults.dart' as DatabaseDefaults;
import 'data/pressed_pill.dart';

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
      setState(() {_pressedPills = null; _loadData();});
    });
  }

  Future<bool> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _setSettingsValues(prefs);
    //Only bother loading the last package worth of pressed pills
    int maxRetrieve = _pillPackageWeeks * 7;
    _pressedPills = await DatabaseDefaults.retrievePressedPills(maxRetrieve);
    for(PressedPill pill in _pressedPills)
      {
        print(pill);
      }
    return true;
  }

  void _setSettingsValues(_preferences) {
    _pillPackageWeeks =
        (_preferences.getInt(SettingsDefaults.PILL_PACKAGE_WEEKS) ?? 4);
    _placeboDays = (_preferences.getInt(SettingsDefaults.PLACEBO_DAYS) ?? 7);
  }
}
