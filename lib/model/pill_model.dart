import 'package:mobx/mobx.dart';

part 'pill_model.g.dart';

class PillModel = PillModelBase with _$PillModel;

abstract class PillModelBase with Store {
  @observable
  bool isPressed = false;

  DateTime currentDate;

  @action
  void setPressed(bool isPressed) {
    this.isPressed = isPressed;
  }

  @action
  void setCurrentDate(DateTime currentDate) {
    this.currentDate = currentDate;
  }
}