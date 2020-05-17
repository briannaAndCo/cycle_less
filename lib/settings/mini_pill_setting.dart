import 'package:flutter/material.dart';
import 'package:pill_reminder/settings/settings_widget.dart';

class MiniPillSetting extends SettingsWidget {
  MiniPillSetting(
      {Key key,
      String displayName,
      bool initialValue,
      String storageName,
      Function loadData})
      : super(
            key: key,
            displayName: displayName,
            initialValue: initialValue,
            storageName: storageName,
            loadData: loadData);

  @override
  _MiniPillSettingState createState() => _MiniPillSettingState();
}

class _MiniPillSettingState extends SettingsWidgetState {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(widget.displayName),
      value: currentValue,
      onChanged: (value) => _showUpdateDialog(value, context),
    );
  }

  _showUpdateDialog(bool value, BuildContext context) {
    Text warning;
    if (value) {
      warning =
          Text("Are you sure you would like to turn the mini pill setting on?");
    } else {
      warning =
          Text("Are you sure you would like to turn the mini pill setting on?");
    }
    Function onSavePressed = () {
      setState(() {
        currentValue = value;
      });
      savePreference(currentValue);
      Navigator.of(context).pop();
      //Force a reload of the data
      widget.loadData();
    };

    showUpdateDialog(context, warning, onSavePressed);
  }
}
