import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsWidget extends StatefulWidget {
  SettingsWidget(
      {Key key,
      this.displayName,
      this.initialValue,
      this.storageName,
      this.loadData})
      : super(key: key);

  final String displayName;
  final dynamic initialValue;
  final String storageName;
  final Function loadData;
}

abstract class SettingsWidgetState<T extends SettingsWidget, V>
    extends State<T> {
  V currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
  }

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
      title: Text("Update " + widget.displayName),
      content: inputWidget,
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
      prefs.setInt(widget.storageName, newValue);
    } else if (newValue is bool) {
      prefs.setBool(widget.storageName, newValue);
    } else {
      throw ("type of preference save not implemented. Implement save for pref type: " +
          newValue.runtimeType.toString());
    }
  }
}
