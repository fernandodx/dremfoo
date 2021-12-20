import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dtos/dream_page_dto.dart';
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

  @observable
  bool isloadingDailyStep = false;


  @action
  Future<ResponseApi<List<Dream>>> _findDreams() async {
    isLoading = true;
    ResponseApi<List<Dream>> responseApi = await _dreamCase.findDreamsForUser();
    msgAlert = responseApi.messageAlert;
    if(responseApi.ok){
      List<Dream> list = responseApi.result!;
      listDream = list;
      isLoading = false;
      isloadingDailyStep = true;
      for(Dream dream in list){
        await _loadHistoryWeekDailyGoal(dream);
        await _loadStepDream(dream);
        await _loadDailyGoalDream(dream);
      }
      isloadingDailyStep = false;
      listDream = list;
    }
    return responseApi;
  }

  @action
  void updateListDream(List<Dream> newList) {
    listDream = ObservableList.of(newList);
  }

  void fetch() async {
    ResponseApi responseApiDream = await _findDreams();
  }

  Future<ResponseApi<List<DailyGoal>>> _loadHistoryWeekDailyGoal(Dream dream) async {
    if(dream.uid != null && dream.uid!.isNotEmpty){
      ResponseApi<List<DailyGoal>> responseApi = await _dreamCase.findHistoryDailyGoalCurrentWeek(dream, DateTime.now());
      msgAlert = responseApi.messageAlert;
      if(responseApi.ok){
        dream.listHistoryWeekDailyGoals = responseApi.result!;
      }
      return responseApi;
    }else{
      return ResponseApi.error(messageAlert: MessageAlert.create("Ops", "Uid == null", TypeAlert.ERROR));
    }
  }

  @action
  Future<ResponseApi<List<StepDream>>> _loadStepDream(Dream dream) async {
    if(dream.uid != null && dream.uid!.isNotEmpty){
      ResponseApi<List<StepDream>> responseApi = await _dreamCase.findStepDreamForUser(dream.uid!);
      msgAlert = responseApi.messageAlert;
      if(responseApi.ok){
        dream.steps = responseApi.result!;
      }
      return responseApi;
    }else{
      return ResponseApi.error(messageAlert: MessageAlert.create("Ops", "Uid == null", TypeAlert.ERROR));
    }
  }

  Future<ResponseApi<List<DailyGoal>>> _loadDailyGoalDream(Dream dream) async {
    if(dream.uid != null && dream.uid!.isNotEmpty){
      ResponseApi<List<DailyGoal>> responseApi = await _dreamCase.findDailyGoalForUser(dream.uid!);
      msgAlert = responseApi.messageAlert;
      if(responseApi.ok){
        dream.dailyGoals = responseApi.result!;
      }
      return responseApi;
    }else{
      return ResponseApi.error(messageAlert: MessageAlert.create("Ops", "Uid == null", TypeAlert.ERROR));
    }
  }

  void detailDream(BuildContext context, Dream dreamSelected) async {
    if(dreamSelected.isDreamWait??false){
      _editDream(context, dreamSelected);
    }else{
      DreamPageDto? _dreamDto = await Navigator.pushNamed(context, "/home/dream/detail", arguments: dreamSelected) as DreamPageDto?;
      if(_dreamDto != null && _dreamDto.dream != null) {
        int index = listDream.indexWhere((dream) => dream.uid == _dreamDto.dream!.uid);
        if(_dreamDto.isRemoveDream){
          listDream.remove(_dreamDto.dream);
        }else{
          listDream[index] = _dreamDto.dream!;
        }
        updateListDream(listDream);
      }
    }
  }

  void _editDream(BuildContext context, Dream dreamSelected) {
    // Modular.to.navigate('/home/dream/detail', arguments: dreamSelected);
    // Modular.to.navigate('/dream/detail', arguments: dreamSelected);
    // Navigator.pushNamed(context, "/home/dream/detail", arguments: dreamSelected);

    Navigator.pushNamed(context, "/home/dream/newDreamWithFocus",
        arguments: DreamPageDto(isDreamWait: dreamSelected.isDreamWait??false, dream: dreamSelected));
  }

  void createFocusDream(BuildContext context, Dream dreamSelected) {
    dreamSelected.isDreamWait = false;
    Navigator.pushNamed(context, "/home/dream/newDreamWithFocus",
        arguments: DreamPageDto(isDreamWait: false, dream: dreamSelected));
  }

  void newDream(BuildContext context){
    Navigator.pushNamed(context, "/home/dream/choiceDream");
    // Modular.to.navigate("/dream/newDream");
  }


}