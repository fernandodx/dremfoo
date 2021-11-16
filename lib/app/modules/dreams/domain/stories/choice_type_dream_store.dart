import 'package:dremfoo/app/model/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dtos/dream_page_dto.dart';
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
    Navigator.pushNamed(context, "/home/dream/newDreamWithFocus",
        arguments: DreamPageDto(isDreamWait: true, dream: null));
  }

  void startNewDreamWithFocus(BuildContext context) {
    // Modular.to.navigate("/dream/newDreamWithFocus");
    Navigator.pushNamed(context, "/home/dream/newDreamWithFocus",
        arguments: DreamPageDto(isDreamWait: false, dream: null));
  }
}