import 'package:flutter/material.dart';
import 'package:pill_reminder/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pill_package.dart';
import 'settings_page.dart';
import 'app_defaults.dart' as AppDefaults;
import 'preferences/settings_constants.dart' as SettingsDefaults;
import 'database_defaults.dart' as DatabaseDefaults;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loaded = false;
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
      future: _loadPrefs(),
      builder: (context, AsyncSnapshot<SharedPreferences> loadedPrefs) {
        Widget body;

        if (loadedPrefs.hasData) {
          if (!_loaded) {
            AppDefaults.hideLoading(context);
            _loaded = true;
          }

          _setPreferenceValues(loadedPrefs.data);

          body = Container(
              child: PillPackage(
                  totalWeeks: _pillPackageWeeks, placeboDays: _placeboDays));
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
                        ).whenComplete(_loadPrefs);
                      })
                ]),
            body: body);
      },
    );
  }

  Future<SharedPreferences> _loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  void _setPreferenceValues(_preferences) {
    _pillPackageWeeks =
        (_preferences.getInt(SettingsDefaults.PILL_PACKAGE_WEEKS) ?? 4);
    _placeboDays = (_preferences.getInt(SettingsDefaults.PLACEBO_DAYS) ?? 7);
  }
}
