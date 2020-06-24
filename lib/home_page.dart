import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cycleless/model/new_pack_indicator.dart';
import 'package:cycleless/model/pill_package_model.dart';
import 'package:cycleless/settings/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/database_defaults.dart' as DatabaseDefaults;
import 'settings/settings_constants.dart' as SettingsDefaults;
import 'settings/settings_page.dart';
import 'widgets/pill_package.dart';
import 'widgets/protection.dart';
import 'model/pill_package_model.dart';
import 'model/settings_model.dart';
import 'app_defaults.dart' as AppDefaults;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PillPackageModel _pillPackageModel = new PillPackageModel();
  SettingsModel _settingsModel = new SettingsModel();

  final NewPackIndicator newPackIndicator = NewPackIndicator();

  @override
  void initState() {
    super.initState();
    DatabaseDefaults.createDatabase();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: _confirmNewPack),
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsPage(
                              settingsModel: _settingsModel,
                            )),
                  );
                })
          ]),
      body: Observer(
          builder: (_) => _pillPackageModel.loadedPills == null
              ? Container()
              : Column(children: [
                  Expanded(
                      child: PillPackage(
                    pillPackageModel: _pillPackageModel,
                    newPack: newPackIndicator.isNewPack,
                    miniPill: _settingsModel.miniPill,
                    totalWeeks: _settingsModel.pillPackageWeeks,
                    placeboDays: _settingsModel.placeboDays,
                    alarmTime: _settingsModel.alarmTime,
                  )),
                  SizedBox(height: 20),
                  Protection(
                    pillPackageModel: _pillPackageModel,
                    totalWeeks: _settingsModel.pillPackageWeeks,
                    placeboDays: _settingsModel.placeboDays,
                    isMiniPill: false,
                  ),
                  SizedBox(height: 40),
                ])),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FlatButton(
        textColor: AppDefaults.getPrimarySwatchColor(),
        child: Text(
          "About",
          style: TextStyle(fontSize: AppDefaults.getPrimaryFontSize()),
        ),
        onPressed: _showAboutDialog,
      ),
    );
  }

  _confirmNewPack() {
    Widget _okButton = FlatButton(
      textColor: AppDefaults.getPrimaryTextColor(),
      child: Text("Yes"),
      onPressed: () {
        newPackIndicator.setTrue();
        Navigator.of(context).pop();
      },
    );
    Widget _cancelButton = FlatButton(
      textColor: AppDefaults.getPrimaryTextColor(),
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the dialog to update the number
    AlertDialog alert = AlertDialog(
      title: Text("New Pack"),
      content: Text("Would you like to start a new pack?"),
      backgroundColor: Colors.black87,
      actions: [_okButton, _cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showAboutDialog() {
    Widget _okButton = FlatButton(
      textColor: AppDefaults.getPrimaryTextColor(),
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget content = new Container(
        height: 260,
        child: Column(children: [
          Text(
            "Purpose",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppDefaults.getPrimaryFontSize()),
          ),
          Text(
            "Cycle Less is an app built to help you skip your period.",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            "Privacy",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppDefaults.getPrimaryFontSize()),
          ),
          Text(
            "Cycle Less will never collect your data. We value your privacy and want to help you keep your data yours.",
            textAlign: TextAlign.center,
          ),
          new InkWell(
              child: new Text('Full Privacy Policy',
                  style: TextStyle(
                    color: Colors.blue,
                    fontStyle: FontStyle.italic,
                  )),
              onTap: _launchPrivacyURL),
          SizedBox(height: 20),
          Text(
            "Contact Us",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppDefaults.getPrimaryFontSize()),
          ),
          Text(
            "Drop us a line! We'd love to hear from you.",
            textAlign: TextAlign.center,
          ),
          new InkWell(
              child: new Text('Send An Email',
                  style: TextStyle(
                    color: Colors.blue,
                    fontStyle: FontStyle.italic,
                  )),
              onTap: _launchContactEmail),
        ]));

    AlertDialog alert = AlertDialog(
      title: Text("About Cycle Less"),
      content: content,
      backgroundColor: Colors.black87,
      actions: [_okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _launchPrivacyURL() async {
    const url = 'http://cycleless.net/#privacy';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchContactEmail() async {
    const url = 'mailto:cycle.less.app@gmail.com?subject=Cycle%20Less%20Feedback';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _setSettingsValues(prefs);
    //Only bother loading the 2 last packages since that is the max required to maintain protection
    int maxRetrieve = _settingsModel.pillPackageWeeks * 7 * 2;
    var pressedPills = await DatabaseDefaults.retrievePressedPills(maxRetrieve);
    _pillPackageModel.setLoadedPressedPills(pressedPills);
  }

  void _setSettingsValues(_preferences) {
    _settingsModel.setPillPackageWeeks(
        _preferences.getInt(SettingsDefaults.PILL_PACKAGE_WEEKS) ?? 4);
    _settingsModel.setPlaceboDays(
        _preferences.getInt(SettingsDefaults.PLACEBO_DAYS) ?? 7);
    _settingsModel
        .setMiniPill(_preferences.getBool(SettingsDefaults.MINI_PILL) ?? false);
    int hours = (_preferences.getInt(SettingsDefaults.HOURS_ALARM_TIME) ?? 12);
    int minutes =
        (_preferences.getInt(SettingsDefaults.MINUTES_ALARM_TIME) ?? 0);
    _settingsModel.setAlarmTime(TimeOfDay(hour: hours, minute: minutes));
  }
}
