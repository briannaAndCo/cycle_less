import 'package:mobx/mobx.dart';

part 'pill_model.g.dart';

class PillModel = PillModelBase with _$PillModel;

abstract class PillModelBase with Store {

  @observable
  int id;
  @observable
  int day;
  @observable
  bool isPressed = false;
  @observable
  DateTime currentDate;
  @observable
  bool isActive;

  @action
  void setId(int id)
  {
    this.id = id;
  }

  @action
  void setDay(int day) {
    this.day = day;
  }

  @action
  void setPressed(bool isPressed) {
    this.isPressed = isPressed;
  }

  @action
  void setCurrentDate(DateTime currentDate) {
    this.currentDate = currentDate;
  }

  @action
  void setIsActive(bool isActive) {
    this.isActive = isActive;
  }
}
