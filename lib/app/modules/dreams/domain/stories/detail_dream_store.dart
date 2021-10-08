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
import 'package:dremfoo/app/api/extensions/util_extensions.dart';

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
   ObservableList<DailyGoal> listHistoryWeekDailyGoals = ObservableList<DailyGoal>.of([]);

   @observable
   DateTime currentDate = DateTime.now();

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

   List<DailyGoal> _findHistoryCurrentDateDailyGoal(Dream dream, DateTime dateSelected) {
      List<DailyGoal> result = listHistoryWeekDailyGoals.where(
              (daily) => daily.lastDateCompleted!.toDate().isSameDate(dateSelected))
             .toList();
      return result;
   }

   Future<ResponseApi<List<DailyGoal>>> _findHistoryWeekDailyGoal(Dream dream) async {

      if(dream.uid != null && dream.uid!.isNotEmpty){
         ResponseApi<List<DailyGoal>> responseApi = await _dreamCase.findHistoryDailyGoalCurrentWeek(dream, DateTime.now());
         msgAlert = responseApi.messageAlert;
         if(responseApi.ok){
            listHistoryWeekDailyGoals = responseApi.result!.asObservable();
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
   void _setListHitoryWeekDailyGoals(List<DailyGoal> listDailyGoal) {
      listHistoryWeekDailyGoals = ObservableList.of(listDailyGoal);
   }

   @action
   void _setListStepDream(List<StepDream> listStepDream) {
      listStepDream = ObservableList.of(listStepDream);
   }

   @action
   void _setCurrentDate(DateTime dateTime) {
      currentDate = dateTime;
   }

   @computed
   double get percentWeekCompleted {
      var daysWeek = 7;
      var countDaily = listDailyGoals.length;
      var countCompletedDailyHist = listHistoryWeekDailyGoals.length;
      return countCompletedDailyHist / (countDaily * daysWeek);
   }

   @computed
   int get countDailyGoal => listDailyGoals.length;

   void _updateListDailyGoal(int index, DailyGoal? dailyGoal) {
      if(dailyGoal != null) {
         List<DailyGoal> listTemp = [];
         listTemp.addAll(listDailyGoals);
         listTemp[index] = dailyGoal;
         _setListDailyGoals(listTemp);
      }
   }

   void _updateListDailyGoalHistWeek(DailyGoal? dailyGoal, DateTime currentDate) {
      if(dailyGoal != null) {
         List<DailyGoal> listTemp = [];
         listTemp.addAll(listHistoryWeekDailyGoals);

         print("LIST WEEK PAST = ${listHistoryWeekDailyGoals.map((e) => e.lastDateCompleted!.toDate())}");

         if(dailyGoal.isHistCompletedDay == true){
            var map = dailyGoal.toMap();
            DailyGoal newDaily = DailyGoal.fromMap(map);
            listTemp.add(newDaily);
         }else{
            int index = listTemp.indexWhere(
                    (hist) {
                       return hist.nameDailyGoal == dailyGoal.nameDailyGoal
                       && hist.lastDateCompleted!.toDate().isSameDate(currentDate);
                    });
            listTemp.removeAt(index);
         }

         _setListHitoryWeekDailyGoals(listTemp);

         print("LIST WEEK NEW = ${listTemp.map((e) => e.lastDateCompleted!.toDate())}");
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
      List<DailyGoal> _listDailyGoalsCurrentDate = _findHistoryCurrentDateDailyGoal(dream, dateTime);
      List<DailyGoal> listCurrentDate = [];

      for(DailyGoal daily in listDailyGoals){
         int index = _listDailyGoalsCurrentDate.indexWhere((hist) => hist.nameDailyGoal == daily.nameDailyGoal);
         daily.isHistCompletedDay = index >= 0;
         listCurrentDate.add(daily);
      }
      _setCurrentDate(dateTime);
      _setListDailyGoals(listCurrentDate);
   }

   void fetch(Dream dream) async {
      // isLoading = true;
      _findStepDream(dream);
      _findDailyGoal(dream);
      _findHistoryWeekDailyGoal(dream);
      // isLoading = false;
   }



   Future<void> updateDailyGoal(DailyGoal? dailyGoal, bool isSelected) async  {
      if(dailyGoal != null) {
         var index = listDailyGoals.indexOf(dailyGoal);
         dailyGoal.lastDateCompleted = isSelected ? Timestamp.fromDate(currentDate) : null;
         dailyGoal.isHistCompletedDay = isSelected;
         ResponseApi responseApi = await _dreamCase.updateDailyGoalDream(dailyGoal, currentDate);
         msgAlert = responseApi.messageAlert;
         if(responseApi.ok){
            _updateListDailyGoal(index, dailyGoal);
            _updateListDailyGoalHistWeek(dailyGoal, currentDate);
         }
      }
   }

   Future<void> updateStepDream(StepDream? stepDream, bool isSelected) async  {
      if(stepDream != null) {
         var index = listStep.indexOf(stepDream);
         stepDream.dateCompleted = isSelected ? Timestamp.fromDate(currentDate) : null;
         ResponseApi responseApi = await _dreamCase.updateStepDream(stepDream);
         msgAlert = responseApi.messageAlert;
         if(responseApi.ok){
            _updateListStepDream(index, stepDream);
         }
      }
   }



}