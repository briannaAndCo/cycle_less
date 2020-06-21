import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/settings_model.dart';

abstract class SettingsWidget extends StatelessWidget {
  SettingsWidget(
      {Key key,
      this.displayName,
      this.settingsModel,
      this.storageName})
      : super(key: key);

  final String displayName;
  final SettingsModel settingsModel;
  final String storageName;

  showUpdateDialog(
      BuildContext context, Widget inputWidget, Function onSavePressed) {
    // set up the buttons
    Widget _saveButton = FlatButton(
      child: Text("Save"),
      onPressed: onSavePressed,
    );
    Widget _cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the dialog to update the number
    AlertDialog alert = AlertDialog(
      title: Text("Update " + displayName),
      content: inputWidget,
      backgroundColor: Colors.black87,
      actions: [_saveButton, _cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  savePreference(newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (newValue is int) {
      prefs.setInt(storageName, newValue);
    } else if (newValue is bool) {
      prefs.setBool(storageName, newValue);
    } else {
      throw ("type of preference save not implemented. Implement save for pref type: " +
          newValue.runtimeType.toString());
    }
  }
}
