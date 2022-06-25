import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'bottom_navigate_store.g.dart';

class BottomNavigateStore = _BottomNavigateStoreBase with _$BottomNavigateStore;
abstract class _BottomNavigateStoreBase with Store {

  @observable
  bool isAppBarVisible = true;

  @observable
  int selectedIndex = 0;

  @action
  void showHideAppBar(bool isAppBarVisible) {
    this.isAppBarVisible = isAppBarVisible;
  }

  @action
  void navigatePageBottomNavigate(int index) {
    this.selectedIndex = index;

    switch(index) {
      case 0 : {
        showHideAppBar(true);
        Modular.to.navigate('/home/dashboard');
        break;
      }
      case 1 : {
        showHideAppBar(false);
        Modular.to.navigate('/home/dream');
        break;
      }
      case 2 : {
        showHideAppBar(false);
        Modular.to.navigate('/home/rank');
        break;
      }
      case 3 : {
        showHideAppBar(false);
        Modular.to.navigate('/home/presentationDailyPlanning');
        break;
      }
    }
  }
}