import 'package:mobx/mobx.dart';

part 'bottom_navigate_store.g.dart';

class BottomNavigateStore = _BottomNavigateStoreBase with _$BottomNavigateStore;
abstract class _BottomNavigateStoreBase with Store {

  @observable
  bool isAppBarVisible = false;

  @action
  void showHideAppBar(bool isAppBarVisible) {
    this.isAppBarVisible = isAppBarVisible;
  } 
}