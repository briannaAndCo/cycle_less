import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pill_reminder/settings/settings_widget.dart';
import '../model/settings_model.dart';
import 'settings_constants.dart' as SettingsConstants;

class MiniPillSetting extends SettingsWidget {
  MiniPillSetting({Key key, SettingsModel settingsModel})
      : super(
            key: key,
            displayName: "Mini Pill",
            settingsModel: settingsModel,
            storageName: SettingsConstants.MINI_PILL);

  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) => SwitchListTile(
              title: Text(displayName),
              value: settingsModel.miniPill,
              onChanged: (value) => _showUpdateDialog(value, context),
            ));

  _showUpdateDialog(bool value, BuildContext context) {
    Text warning;
    if (value) {
      warning =
          Text("Are you sure you would like to turn the mini pill setting on?");
    } else {
      warning = Text(
          "Are you sure you would like to turn the mini pill setting off?");
    }
    Function onSavePressed = () {
      settingsModel.setMiniPill(value);
      savePreference(value);
      Navigator.of(context).pop();
    };

    showUpdateDialog(context, warning, onSavePressed);
  }
}
