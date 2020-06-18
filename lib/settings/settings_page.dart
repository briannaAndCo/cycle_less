import 'package:flutter/material.dart';
import 'package:pill_reminder/settings/alarm_setting.dart';
import 'package:pill_reminder/settings/mini_pill_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_defaults.dart' as AppDefaults;
import 'number_setting.dart';
import 'settings_constants.dart' as SettingsConstants;

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferences _sharedPrefs;
  bool _loaded = false;
  //preference values to initialize
  int _pillPackageWeeks;
  int _placeboDays;
  bool _miniPill;
  TimeOfDay _alarmTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AppDefaults.showLoading(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: _loadPrefs(),
        builder: (context, loadedPrefs) {
          Widget body;

          if (loadedPrefs.hasData) {
            if (!_loaded) {
              _setPreferences(loadedPrefs.data);
              AppDefaults.hideLoading(context);
              _loaded = true;
              print("pill package weeks");
              print(_pillPackageWeeks);
            }
            body = _buildSettingsView();
          } else {
            body = Container();
          }

          return Scaffold(
              appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text("Settings"),
              ),
              body: body);
        });
  }

  Widget _buildSettingsView() => ListView(
        children: <Widget>[
          NumberSetting(
            displayName: "Pill Weeks",
            initialValue: _pillPackageWeeks,
            storageName: SettingsConstants.PILL_PACKAGE_WEEKS,
            loadData: _updateData,
            enabled: true,
          ),
          NumberSetting(
            displayName: "Placebo Days",
            initialValue: _placeboDays,
            storageName: SettingsConstants.PLACEBO_DAYS,
            loadData: _updateData,
            enabled: !_miniPill,
          ),
          MiniPillSetting(
            displayName: "Mini Pill",
            initialValue: _miniPill,
            storageName: SettingsConstants.MINI_PILL,
            loadData: _updateData,
          ),
          AlarmSetting(
            displayName: "Alarm",
            initialValue: _alarmTime,
            storageName: "",
            loadData: _updateData,
          )
        ],
      );

  Future<SharedPreferences> _loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  void _setPreferences(loadedPrefs) {
    print("got prefs");
    print(loadedPrefs);
    _sharedPrefs = loadedPrefs;
    _pillPackageWeeks = (_sharedPrefs.getInt(SettingsConstants.PILL_PACKAGE_WEEKS) ?? 4);
    _placeboDays = (_sharedPrefs.getInt(SettingsConstants.PLACEBO_DAYS) ?? 7);
    _miniPill = (_sharedPrefs.getBool(SettingsConstants.MINI_PILL) ?? false);
    int alarmHours = (_sharedPrefs.getInt(SettingsConstants.HOURS_ALARM_TIME) ?? 12);
    int alarmMinutes = (_sharedPrefs.getInt(SettingsConstants.MINUTES_ALARM_TIME) ?? 0);
    _alarmTime = TimeOfDay(hour: alarmHours, minute: alarmMinutes);

    print("set prefs");
  }

  _updateData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _loadData();
      });
    });
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _setPreferences(prefs);
  }
}
