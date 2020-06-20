// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_package_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PillPackageModel on PillPackageModelBase, Store {
  final _$currentPackageAtom =
      Atom(name: 'PillPackageModelBase.currentPackage');

  @override
  Map<int, PressedPill> get currentPackage {
    _$currentPackageAtom.context.enforceReadPolicy(_$currentPackageAtom);
    _$currentPackageAtom.reportObserved();
    return super.currentPackage;
  }

  @override
  set currentPackage(Map<int, PressedPill> value) {
    _$currentPackageAtom.context.conditionallyRunInAction(() {
      super.currentPackage = value;
      _$currentPackageAtom.reportChanged();
    }, _$currentPackageAtom, name: '${_$currentPackageAtom.name}_set');
  }

  final _$loadedPillsAtom = Atom(name: 'PillPackageModelBase.loadedPills');

  @override
  ObservableList<PressedPill> get loadedPills {
    _$loadedPillsAtom.context.enforceReadPolicy(_$loadedPillsAtom);
    _$loadedPillsAtom.reportObserved();
    return super.loadedPills;
  }

  @override
  set loadedPills(ObservableList<PressedPill> value) {
    _$loadedPillsAtom.context.conditionallyRunInAction(() {
      super.loadedPills = value;
      _$loadedPillsAtom.reportChanged();
    }, _$loadedPillsAtom, name: '${_$loadedPillsAtom.name}_set');
  }

  final _$PillPackageModelBaseActionController =
      ActionController(name: 'PillPackageModelBase');

  @override
  dynamic setLoadedPressedPills(List<PressedPill> loadedPills) {
    final _$actionInfo = _$PillPackageModelBaseActionController.startAction();
    try {
      return super.setLoadedPressedPills(loadedPills);
    } finally {
      _$PillPackageModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removePressedPill(int pillId) {
    final _$actionInfo = _$PillPackageModelBaseActionController.startAction();
    try {
      return super.removePressedPill(pillId);
    } finally {
      _$PillPackageModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPressedPill(PressedPill pill) {
    final _$actionInfo = _$PillPackageModelBaseActionController.startAction();
    try {
      return super.setPressedPill(pill);
    } finally {
      _$PillPackageModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentPackage(Map<int, PressedPill> currentPackage) {
    final _$actionInfo = _$PillPackageModelBaseActionController.startAction();
    try {
      return super.setCurrentPackage(currentPackage);
    } finally {
      _$PillPackageModelBaseActionController.endAction(_$actionInfo);
    }
  }
}
