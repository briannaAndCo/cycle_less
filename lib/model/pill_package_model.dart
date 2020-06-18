import 'package:mobx/mobx.dart';
import '../data/pressed_pill.dart';

part 'pill_package_model.g.dart';

class PillPackageModel = PillPackageModelBase with _$PillPackageModel;

abstract class PillPackageModelBase with Store {
  @observable
  Map<int, PressedPill> currentPackage = new Map();

  @action
  void setCurrentPackage(Map<int, PressedPill> currentPackage) {
    this.currentPackage = currentPackage;
  }
}