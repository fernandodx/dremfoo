import 'package:mobx/mobx.dart';

part 'dreams_store.g.dart';

class DreamsStore = _DreamsStoreBase with _$DreamsStore;
abstract class _DreamsStoreBase with Store {

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  } 
}