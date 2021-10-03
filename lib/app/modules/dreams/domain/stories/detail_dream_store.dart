import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/contract/idream_case.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'detail_dream_store.g.dart';

class DetailDreamStore = _DetailDreamStoreBase with _$DetailDreamStore;
abstract class _DetailDreamStoreBase with Store {

   IDreamCase _dreamCase;
   _DetailDreamStoreBase(this._dreamCase);

   @observable
   bool isLoading = false;

   @observable
   MessageAlert? msgAlert;

   @observable
   ObservableList<DailyGoal> listDailyGoals = ObservableList<DailyGoal>.of([]);

   @observable
   ObservableList<StepDream> listStep = ObservableList<StepDream>.of([]);

   @observable
   DateTime currentDate = DateTime.now();

   // List<DailyGoal> _listDailyGoalsCurrentDate = [];

   var user =  Modular.get<UserRevo>();

   @action
   Future<ResponseApi<List<DailyGoal>>> _findDailyGoal(Dream dream) async {

      if(dream.uid != null && dream.uid!.isNotEmpty){
         ResponseApi<List<DailyGoal>> responseApi = await _dreamCase.findDailyGoalForUser(dream.uid!);
         msgAlert = responseApi.messageAlert;
         if(responseApi.ok){
            listDailyGoals = responseApi.result!.asObservable();
         }
         return responseApi;
      }else{
         return ResponseApi.error(messageAlert: MessageAlert.create("Ops", "Uid == null", TypeAlert.ERROR));
      }
   }

   @action
   Future<ResponseApi<List<StepDream>>> _findStepDream(Dream dream) async {

      if(dream.uid != null && dream.uid!.isNotEmpty){
         ResponseApi<List<StepDream>> responseApi = await _dreamCase.findStepDreamForUser(dream.uid!);
         msgAlert = responseApi.messageAlert;
         if(responseApi.ok){
            listStep = responseApi.result!.asObservable();
         }
         return responseApi;
      }else{
         return ResponseApi.error(messageAlert: MessageAlert.create("Ops", "Uid == null", TypeAlert.ERROR));
      }
   }


   Future<ResponseApi<List<DailyGoal>>> _findHistoryCurrentDateDailyGoal(Dream dream, DateTime dateSelected) async {
      if(dream.uid != null && dream.uid!.isNotEmpty){
         print("FIND -> ${currentDate.toString()}");
         ResponseApi<List<DailyGoal>> responseApi = await _dreamCase.findHistoryDailyGoalCurrentDate(dream, dateSelected);
         msgAlert = responseApi.messageAlert;
         if(responseApi.ok){
            print("RESPONSE OK -> ${responseApi.result!}");
         }
         return responseApi;
      }else{
         return ResponseApi.error(messageAlert: MessageAlert.create("Ops", "Uid == null", TypeAlert.ERROR));
      }
   }

   @action
   void _setListDailyGoals(List<DailyGoal> listDailyGoal) {
      listDailyGoals = ObservableList.of(listDailyGoal);
   }

   @action
   void _setListStepDream(List<StepDream> listStepDream) {
      listStepDream = ObservableList.of(listStepDream);
   }

   @action
   void _setCurrentDate(DateTime dateTime) {
      currentDate = dateTime;
   }

   void _updateListDailyGoal(int index, DailyGoal? dailyGoal) {
      if(dailyGoal != null) {
         List<DailyGoal> listTemp = [];
         listTemp.addAll(listDailyGoals);
         listTemp[index] = dailyGoal;
         _setListDailyGoals(listTemp);
      }
   }


   void _updateListStepDream(int index, StepDream? stepDream) {
      if(stepDream != null) {
         List<StepDream> listTemp = [];
         listTemp.addAll(listStep);
         listTemp[index] = stepDream;
         _setListStepDream(listTemp);
      }
   }

   Future<void> changeCurrentDayForDailyGoal(Dream dream, DateTime dateTime) async {
      ResponseApi<List<DailyGoal>> responseHist = await _findHistoryCurrentDateDailyGoal(dream, dateTime);
      if(responseHist.ok){
         List<DailyGoal> listCurrentDate = [];
         List<DailyGoal> _listDailyGoalsCurrentDate = responseHist.result!;
         for(DailyGoal daily in listDailyGoals){
            int index = _listDailyGoalsCurrentDate.indexWhere((hist) => hist.nameDailyGoal == daily.nameDailyGoal);
            daily.isHistCompletedDay = index >= 0;
            listCurrentDate.add(daily);
         }
         _setCurrentDate(dateTime);
         _setListDailyGoals(listCurrentDate);
      }
   }

   void fetch(Dream dream) async {
      // isLoading = true;
      _findStepDream(dream);
      // await _findHistoryCurrentDateDailyGoal(dream);
     _findDailyGoal(dream);
      // isLoading = false;
   }



   Future<void> updateDailyGoal(DailyGoal? dailyGoal, bool isSelected) async  {
      if(dailyGoal != null) {
         var index = listDailyGoals.indexOf(dailyGoal);
         dailyGoal.lastDateCompleted = isSelected ? Timestamp.now() : null;
         ResponseApi responseApi = await _dreamCase.updateDailyGoalDream(dailyGoal);
         msgAlert = responseApi.messageAlert;
         if(responseApi.ok){
            _updateListDailyGoal(index, dailyGoal);
         }
      }
   }

   Future<void> updateStepDream(StepDream? stepDream, bool isSelected) async  {
      if(stepDream != null) {
         var index = listStep.indexOf(stepDream);
         stepDream.dateCompleted = isSelected ? Timestamp.now() : null;
         ResponseApi responseApi = await _dreamCase.updateStepDream(stepDream);
         msgAlert = responseApi.messageAlert;
         if(responseApi.ok){
            _updateListStepDream(index, stepDream);
         }
      }
   }



}