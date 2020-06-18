import 'package:mobx/mobx.dart';

part 'new_pack_indicator.g.dart';

class NewPackIndicator = NewPackIndicatorBase with _$NewPackIndicator;

abstract class NewPackIndicatorBase with Store {
  @observable
  bool isNewPack = false;

  @action
  void setTrue() {
    isNewPack = true;
  }
}
