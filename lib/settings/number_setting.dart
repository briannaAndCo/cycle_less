import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../app_defaults.dart' as AppConstants;

class NumberSetting extends StatefulWidget {
  NumberSetting(
      {Key key, this.displayName, this.initialValue, this.storageName})
      : super(key: key);

  final String displayName;
  final int initialValue;
  final String storageName;

  @override
  _NumberSettingState createState() => _NumberSettingState();
}

class _NumberSettingState extends State<NumberSetting> {
  _NumberSettingState();

  int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Text(widget.displayName),
      trailing: Text(_currentValue.toString()),
      onTap: () {
        _showUpdateDialog(context);
      },
    );
  }

  _showUpdateDialog(BuildContext context) {
    TextEditingController numberController = new TextEditingController();

    TextField numberInput = TextField(
      maxLines: 1,
      keyboardType: TextInputType.number,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      controller: numberController
    );

    // set up the buttons
    Widget _saveButton = FlatButton(
      child: Text("Save"),
      onPressed: () {
        int numberInput = int.parse(numberController.text);
        setState(() {
          _currentValue = numberInput;
        });
        _savePreference(numberInput);
        Navigator.of(context).pop();
      },
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
      content: numberInput,
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

  _savePreference(newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(widget.storageName, newValue);
  }
}
