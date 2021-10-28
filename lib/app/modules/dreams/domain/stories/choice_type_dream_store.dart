import 'package:dremfoo/app/model/dream.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'choice_type_dream_store.g.dart';

class ChoiceTypeDreamStore = _ChoiceTypeDreamStoreBase with _$ChoiceTypeDreamStore;
abstract class _ChoiceTypeDreamStoreBase with Store {

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }

  void startNewDreamAwait(BuildContext context) {
    // Navigator.pushNamed(context, "/home/dream/choiceDream");
    // Modular.to.navigate("/dream/newDreamWait");
    Navigator.pushNamed(context, "/home/dream/newDreamWait");
  }

  void startNewDreamWithFocus(BuildContext context) {
    // Modular.to.navigate("/dream/newDreamWithFocus");
    Navigator.pushNamed(context, "/home/dream/newDreamWithFocus", arguments: true); //TODO PAssar parametros melhor
  }
}