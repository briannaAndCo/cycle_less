import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cycleless/settings/settings_widget.dart';
import '../model/settings_model.dart';
import 'settings_constants.dart' as SettingsConstants;

class PackageWeeksSetting extends SettingsWidget {
  PackageWeeksSetting(
      {Key key,
      SettingsModel settingsModel})
      : super(
    key: key,
      displayName: "Package Weeks",
      settingsModel: settingsModel,
      storageName: SettingsConstants.PILL_PACKAGE_WEEKS);
  
  @override
  Widget build(BuildContext context) => Observer(builder: (_) => ListTile(
      title: Text(displayName),
      trailing: Text(settingsModel.pillPackageWeeks.toString()),
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
      settingsModel.setPillPackageWeeks(numberInput);
      savePreference(numberInput);
      Navigator.of(context).pop();
    };

    showUpdateDialog(context, numberInput, onSavePressed);
  }
}
