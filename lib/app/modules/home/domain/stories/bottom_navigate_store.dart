import 'package:mobx/mobx.dart';

part 'bottom_navigate_store.g.dart';

class BottomNavigateStore = _BottomNavigateStoreBase with _$BottomNavigateStore;
abstract class _BottomNavigateStoreBase with Store {

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  } 
}