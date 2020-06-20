import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'settings_model.g.dart';

class SettingsModel = SettingsModelBase with _$SettingsModel;

abstract class SettingsModelBase with Store {

  @observable
  int pillPackageWeeks;
  @observable
  int placeboDays;
  @observable
  bool miniPill;
  @observable
  TimeOfDay alarmTime;

  @action
  void setPillPackageWeeks(int value) {
    pillPackageWeeks = value;
  }

  @action
  void setPlaceboDays(int value) {
    placeboDays = value;
  }

  @action
  void setMiniPill(bool value) {
    miniPill = value;
  }

  @action
  void setAlarmTime(TimeOfDay value) {
    alarmTime = value;
  }
}