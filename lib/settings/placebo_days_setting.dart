import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cycleless/settings/settings_widget.dart';
import '../model/settings_model.dart';
import 'settings_constants.dart' as SettingsConstants;

class PlaceboDaysSetting extends SettingsWidget {
  PlaceboDaysSetting(
      {Key key,
      SettingsModel settingsModel})
      : super(
            key: key,
            displayName: "Placebo Days",
            settingsModel: settingsModel,
            storageName: SettingsConstants.PLACEBO_DAYS);
  
  @override
  Widget build(BuildContext context) => Observer(builder: (_) => ListTile(
      title: Text(displayName),
      trailing: Text(settingsModel.placeboDays.toString()),
      enabled: !settingsModel.miniPill,
      onTap: () {
        _showUpdateDialog(context);
      },
    ));

  _showUpdateDialog(BuildContext context) {
    TextEditingController numberController = new TextEditingController();

    TextField numberInput = TextField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        controller: numberController);

    Function onSavePressed = () {
      int numberInput = int.parse(numberController.text);
      settingsModel.setPlaceboDays(numberInput);
      savePreference(numberInput);
      Navigator.of(context).pop();
    };

    showUpdateDialog(context, numberInput, onSavePressed);
  }
}
