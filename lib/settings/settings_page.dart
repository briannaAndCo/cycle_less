import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'number_setting.dart';
import 'settings_constants.dart' as SettingsConstants;
import '../app_defaults.dart' as AppDefaults;
import 'dart:developer' as developer;

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
            }
            body = ListView(
              children: <Widget>[
                NumberSetting(
                    displayName: "Pill Weeks",
                    initialValue: _pillPackageWeeks,
                    storageName: SettingsConstants.PILL_PACKAGE_WEEKS),
                NumberSetting(
                    displayName: "Placebo Days",
                    initialValue: _placeboDays,
                    storageName: SettingsConstants.PLACEBO_DAYS)
              ],
            );
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

  Future<SharedPreferences> _loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  void _setPreferences(loadedPrefs) {
    _sharedPrefs = loadedPrefs;
    _pillPackageWeeks =
        (_sharedPrefs.getInt(SettingsConstants.PILL_PACKAGE_WEEKS) ?? 0);
    _placeboDays = (_sharedPrefs.getInt(SettingsConstants.PLACEBO_DAYS) ?? 0);
  }
}
