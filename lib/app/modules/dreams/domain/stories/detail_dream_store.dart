import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'detail_dream_store.g.dart';

class DetailDreamStore = _DetailDreamStoreBase with _$DetailDreamStore;
abstract class _DetailDreamStoreBase with Store {

  var user =  Modular.get<UserRevo>();
  var dream = Modular.get<Dream>();

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  } 
}