import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/contract/idream_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'dream_store.g.dart';

class DreamStore = _DreamStoreBase with _$DreamStore;
abstract class _DreamStoreBase with Store {

  IDreamCase _dreamCase;
  _DreamStoreBase(this._dreamCase);

  @observable
  bool isLoading = false;

  @observable
  MessageAlert? msgAlert;

  @observable
  List<Dream> listDream = ObservableList<Dream>();

  //TODO Criar metodos para atualizar um elemento do listDream
  //add Steps
  //add dailyGoals
  //TODO Esse metodo vai ser chamado quando o usuário apertar a seta para expandir o sonho

  Future<ResponseApi<List<Dream>>> _findDreams() async {
    ResponseApi<List<Dream>> responseApi = await _dreamCase.findDreamsForUser();
    msgAlert = responseApi.messageAlert;
    if(responseApi.ok){
      listDream = responseApi.result!;
    }
    return responseApi;
  }



  void fetch() async {
    isLoading = true;
    ResponseApi responseApiDream = await _findDreams();
    isLoading = false;
  }

  void editDream(BuildContext context, Dream dreamSelected) {
    print("NAVAGAR PARA PAGINA DE DETALHE");
    // Modular.to.navigate('/home/dream/detail', arguments: dreamSelected);
    // Modular.to.navigate('/dream/detail', arguments: dreamSelected);
    Navigator.pushNamed(context, "/home/dream/detail", arguments: dreamSelected);
  }

  void newDream(BuildContext context){
    Navigator.pushNamed(context, "/home/dream/choiceDream");
    // Modular.to.navigate("/dream/newDream");
  }


}