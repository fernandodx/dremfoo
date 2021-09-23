import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/contract/idream_case.dart';
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

  Future<ResponseApi<List<DailyGoal>>> findDailyGoal(Dream dream) async {

    ResponseApi<List<DailyGoal>> responseApi = await _dreamCase.findDailyGoalForUser("UID");
    msgAlert = responseApi.messageAlert;
    if(responseApi.ok){
      var listDailyGoal = responseApi.result!;
      //add a listDream.get()
    }
    return responseApi;
  }

  Future<ResponseApi<List<StepDream>>> findStepDream(Dream dream) async {
    ResponseApi<List<StepDream>> responseApi = await _dreamCase.findStepDreamForUser("UID");
    msgAlert = responseApi.messageAlert;
    if(responseApi.ok){
      var listStep = responseApi.result!;
      //add a listDream.get()
    }
    return responseApi;
  }

  void fetch() async {
    isLoading = true;
    ResponseApi responseApiDream = await _findDreams();
    isLoading = false;
  }


}