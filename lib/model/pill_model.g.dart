// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PillModel on PillModelBase, Store {
  final _$idAtom = Atom(name: 'PillModelBase.id');

  @override
  int get id {
    _$idAtom.context.enforceReadPolicy(_$idAtom);
    _$idAtom.reportObserved();
    return super.id;
  }

  @override
  set id(int value) {
    _$idAtom.context.conditionallyRunInAction(() {
      super.id = value;
      _$idAtom.reportChanged();
    }, _$idAtom, name: '${_$idAtom.name}_set');
  }

  final _$dayAtom = Atom(name: 'PillModelBase.day');

  @override
  int get day {
    _$dayAtom.context.enforceReadPolicy(_$dayAtom);
    _$dayAtom.reportObserved();
    return super.day;
  }

  @override
  set day(int value) {
    _$dayAtom.context.conditionallyRunInAction(() {
      super.day = value;
      _$dayAtom.reportChanged();
    }, _$dayAtom, name: '${_$dayAtom.name}_set');
  }

  final _$isPressedAtom = Atom(name: 'PillModelBase.isPressed');

  @override
  bool get isPressed {
    _$isPressedAtom.context.enforceReadPolicy(_$isPressedAtom);
    _$isPressedAtom.reportObserved();
    return super.isPressed;
  }

  @override
  set isPressed(bool value) {
    _$isPressedAtom.context.conditionallyRunInAction(() {
      super.isPressed = value;
      _$isPressedAtom.reportChanged();
    }, _$isPressedAtom, name: '${_$isPressedAtom.name}_set');
  }

  final _$currentDateAtom = Atom(name: 'PillModelBase.currentDate');

  @override
  DateTime get currentDate {
    _$currentDateAtom.context.enforceReadPolicy(_$currentDateAtom);
    _$currentDateAtom.reportObserved();
    return super.currentDate;
  }

  @override
  set currentDate(DateTime value) {
    _$currentDateAtom.context.conditionallyRunInAction(() {
      super.currentDate = value;
      _$currentDateAtom.reportChanged();
    }, _$currentDateAtom, name: '${_$currentDateAtom.name}_set');
  }

  final _$isActiveAtom = Atom(name: 'PillModelBase.isActive');

  @override
  bool get isActive {
    _$isActiveAtom.context.enforceReadPolicy(_$isActiveAtom);
    _$isActiveAtom.reportObserved();
    return super.isActive;
  }

  @override
  set isActive(bool value) {
    _$isActiveAtom.context.conditionallyRunInAction(() {
      super.isActive = value;
      _$isActiveAtom.reportChanged();
    }, _$isActiveAtom, name: '${_$isActiveAtom.name}_set');
  }

  final _$PillModelBaseActionController =
      ActionController(name: 'PillModelBase');

  @override
  void setId(int id) {
    final _$actionInfo = _$PillModelBaseActionController.startAction();
    try {
      return super.setId(id);
    } finally {
      _$PillModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDay(int day) {
    final _$actionInfo = _$PillModelBaseActionController.startAction();
    try {
      return super.setDay(day);
    } finally {
      _$PillModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPressed(bool isPressed) {
    final _$actionInfo = _$PillModelBaseActionController.startAction();
    try {
      return super.setPressed(isPressed);
    } finally {
      _$PillModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentDate(DateTime currentDate) {
    final _$actionInfo = _$PillModelBaseActionController.startAction();
    try {
      return super.setCurrentDate(currentDate);
    } finally {
      _$PillModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsActive(bool isActive) {
    final _$actionInfo = _$PillModelBaseActionController.startAction();
    try {
      return super.setIsActive(isActive);
    } finally {
      _$PillModelBaseActionController.endAction(_$actionInfo);
    }
  }
}
