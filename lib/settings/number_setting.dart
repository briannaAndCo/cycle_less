import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pill_reminder/settings/settings_widget.dart';

class NumberSetting extends SettingsWidget {
  NumberSetting(
      {Key key,
      String displayName,
      int initialValue,
      String storageName,
      Function loadData,
      this.enabled})
      : super(
            key: key,
            displayName: displayName,
            initialValue: initialValue,
            storageName: storageName,
            loadData: loadData);

  final bool enabled;

  @override
  SettingsWidgetState createState() => _NumberSettingState();
}

class _NumberSettingState extends SettingsWidgetState<NumberSetting, int> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.displayName),
      trailing: Text(currentValue.toString()),
      enabled: widget.enabled,
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
        controller: numberController);

    Function onSavePressed = () {
      int numberInput = int.parse(numberController.text);
      setState(() {
        currentValue = numberInput;
      });
      savePreference(numberInput);
      Navigator.of(context).pop();
    };

    showUpdateDialog(context, numberInput, onSavePressed);
  }
}
