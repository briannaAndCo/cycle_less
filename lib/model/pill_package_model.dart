import 'package:mobx/mobx.dart';
import '../data/pressed_pill.dart';

part 'pill_package_model.g.dart';

class PillPackageModel = PillPackageModelBase with _$PillPackageModel;

abstract class PillPackageModelBase with Store {

  @observable
  Map<int, PressedPill> currentPackage = new Map();

  @observable
  ObservableList<PressedPill> loadedPills;

  @action
  setLoadedPressedPills(List<PressedPill> loadedPills) {
   this.loadedPills = ObservableList<PressedPill>.of(loadedPills);
  }

  @action
  removePressedPill(int pillId)
  {
    loadedPills.removeWhere((item) => item.id == pillId);
  }

  @action
  setPressedPill(PressedPill pill)
  {
    loadedPills.insert(0, pill);
  }

  @action
  void setCurrentPackage(Map<int, PressedPill> currentPackage) {
    this.currentPackage = currentPackage;
  }
}
