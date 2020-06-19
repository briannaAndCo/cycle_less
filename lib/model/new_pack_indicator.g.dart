// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_pack_indicator.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$NewPackIndicator on NewPackIndicatorBase, Store {
  final _$isNewPackAtom = Atom(name: 'NewPackIndicatorBase.isNewPack');

  @override
  bool get isNewPack {
    _$isNewPackAtom.context.enforceReadPolicy(_$isNewPackAtom);
    _$isNewPackAtom.reportObserved();
    return super.isNewPack;
  }

  @override
  set isNewPack(bool value) {
    _$isNewPackAtom.context.conditionallyRunInAction(() {
      super.isNewPack = value;
      _$isNewPackAtom.reportChanged();
    }, _$isNewPackAtom, name: '${_$isNewPackAtom.name}_set');
  }

  final _$NewPackIndicatorBaseActionController =
      ActionController(name: 'NewPackIndicatorBase');

  @override
  void setTrue() {
    final _$actionInfo = _$NewPackIndicatorBaseActionController.startAction();
    try {
      return super.setTrue();
    } finally {
      _$NewPackIndicatorBaseActionController.endAction(_$actionInfo);
    }
  }
}
