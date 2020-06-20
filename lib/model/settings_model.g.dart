// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SettingsModel on SettingsModelBase, Store {
  final _$pillPackageWeeksAtom =
      Atom(name: 'SettingsModelBase.pillPackageWeeks');

  @override
  int get pillPackageWeeks {
    _$pillPackageWeeksAtom.context.enforceReadPolicy(_$pillPackageWeeksAtom);
    _$pillPackageWeeksAtom.reportObserved();
    return super.pillPackageWeeks;
  }

  @override
  set pillPackageWeeks(int value) {
    _$pillPackageWeeksAtom.context.conditionallyRunInAction(() {
      super.pillPackageWeeks = value;
      _$pillPackageWeeksAtom.reportChanged();
    }, _$pillPackageWeeksAtom, name: '${_$pillPackageWeeksAtom.name}_set');
  }

  final _$placeboDaysAtom = Atom(name: 'SettingsModelBase.placeboDays');

  @override
  int get placeboDays {
    _$placeboDaysAtom.context.enforceReadPolicy(_$placeboDaysAtom);
    _$placeboDaysAtom.reportObserved();
    return super.placeboDays;
  }

  @override
  set placeboDays(int value) {
    _$placeboDaysAtom.context.conditionallyRunInAction(() {
      super.placeboDays = value;
      _$placeboDaysAtom.reportChanged();
    }, _$placeboDaysAtom, name: '${_$placeboDaysAtom.name}_set');
  }

  final _$miniPillAtom = Atom(name: 'SettingsModelBase.miniPill');

  @override
  bool get miniPill {
    _$miniPillAtom.context.enforceReadPolicy(_$miniPillAtom);
    _$miniPillAtom.reportObserved();
    return super.miniPill;
  }

  @override
  set miniPill(bool value) {
    _$miniPillAtom.context.conditionallyRunInAction(() {
      super.miniPill = value;
      _$miniPillAtom.reportChanged();
    }, _$miniPillAtom, name: '${_$miniPillAtom.name}_set');
  }

  final _$alarmTimeAtom = Atom(name: 'SettingsModelBase.alarmTime');

  @override
  TimeOfDay get alarmTime {
    _$alarmTimeAtom.context.enforceReadPolicy(_$alarmTimeAtom);
    _$alarmTimeAtom.reportObserved();
    return super.alarmTime;
  }

  @override
  set alarmTime(TimeOfDay value) {
    _$alarmTimeAtom.context.conditionallyRunInAction(() {
      super.alarmTime = value;
      _$alarmTimeAtom.reportChanged();
    }, _$alarmTimeAtom, name: '${_$alarmTimeAtom.name}_set');
  }

  final _$SettingsModelBaseActionController =
      ActionController(name: 'SettingsModelBase');

  @override
  void setPillPackageWeeks(int value) {
    final _$actionInfo = _$SettingsModelBaseActionController.startAction();
    try {
      return super.setPillPackageWeeks(value);
    } finally {
      _$SettingsModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPlaceboDays(int value) {
    final _$actionInfo = _$SettingsModelBaseActionController.startAction();
    try {
      return super.setPlaceboDays(value);
    } finally {
      _$SettingsModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMiniPill(bool value) {
    final _$actionInfo = _$SettingsModelBaseActionController.startAction();
    try {
      return super.setMiniPill(value);
    } finally {
      _$SettingsModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAlarmTime(TimeOfDay value) {
    final _$actionInfo = _$SettingsModelBaseActionController.startAction();
    try {
      return super.setAlarmTime(value);
    } finally {
      _$SettingsModelBaseActionController.endAction(_$actionInfo);
    }
  }
}
