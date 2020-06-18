// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PillModel on PillModelBase, Store {
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

  final _$PillModelBaseActionController =
      ActionController(name: 'PillModelBase');

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
}
