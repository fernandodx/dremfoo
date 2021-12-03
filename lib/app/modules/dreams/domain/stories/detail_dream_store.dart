import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dtos/dream_page_dto.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/dream_store.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/contract/idream_case.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/utils/date_util.dart';
import 'package:flutter/material.dart';
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
   ObservableList<DailyGoal> listHistoryYaerlyMonthDailyGoals = ObservableList<DailyGoal>.of([]);

   @observable
   DateTime currentDate = DateTime.now();

   @observable
   bool isChartWeek = true;

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

   Future<ResponseApi<List<DailyGoal>>> _findHistoryYearlyMonthDailyGoal(Dream dream) async {
      if(dream.uid != null && dream.uid!.isNotEmpty){
         ResponseApi<List<DailyGoal>> responseApi = await _dreamCase.findHistoryDailyGoalCurrentYearlyMonth(dream, currentDate);
         msgAlert = responseApi.messageAlert;
         if(responseApi.ok){
            listHistoryYaerlyMonthDailyGoals = responseApi.result!.asObservable();
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
   void _setListHitoryMonthDailyGoals(List<DailyGoal> listDailyGoal) {
      listHistoryYaerlyMonthDailyGoals = ObservableList.of(listDailyGoal);
   }

   @action
   void _isChartWeek(bool isWeek){
      isChartWeek = isWeek;
   }

   @action
   void _setListStepDream(List<StepDream> newListStep) {
      listStep = ObservableList.of(newListStep);
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
   double get percentMonthCompleted {
      var daysInMonth = DateUtil().daysInMonth(currentDate.month, currentDate.year);
      print("dias no mes= $daysInMonth");
      var countDaily = listDailyGoals.length;
      print("qtd metas= $countDaily");

      var listMonth = listHistoryYaerlyMonthDailyGoals.where(
                       (hist) => hist.lastDateCompleted?.toDate().month == currentDate.month)
                       .toList();

      var countCompletedDailyHist = listMonth.length;
      print("historico cumprido= $countCompletedDailyHist");
      print("total = ${(countDaily * daysInMonth)}");
      return countCompletedDailyHist / (countDaily * daysInMonth);
   }

   @computed
   int get countDailyGoal => listDailyGoals.length;

   @computed
   int get countDailyGoalMaxMonth {
      var countDaily = listDailyGoals.length;
      var daysInMonth = DateUtil().daysInMonth(currentDate.month, currentDate.year);
      return countDaily * daysInMonth;
   }

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
      }
   }

   void _updateListDailyGoalHistMonth(DailyGoal? dailyGoal, DateTime currentDate) {
      if(dailyGoal != null) {
         List<DailyGoal> listTemp = [];
         listTemp.addAll(listHistoryYaerlyMonthDailyGoals);

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
            if(index > 0){
               listTemp.removeAt(index);
            }
         }
         _setListHitoryMonthDailyGoals(listTemp);
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
            _updateListDailyGoalHistMonth(dailyGoal, currentDate);
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

   Future<void> archiveDream(BuildContext context, Dream dream) async {
      isLoading = true;
      ResponseApi responseApi = await _dreamCase.archiveDream(dream);
      msgAlert = responseApi.messageAlert;
      isLoading = false;
      if(responseApi.ok){
         // Navigator.pushNamed(context, Modular.initialRoute);
         // Modular.to.navigate("/home/dream");
         Navigator.pop(context, DreamPageDto(isRemoveDream: true, dream: dream));
      }
   }

   Future<void> realizedDream(BuildContext context, Dream dream) async {
      isLoading = true;
      ResponseApi responseApi = await _dreamCase.realizedDream(dream, dateFinish: DateTime.now());
      msgAlert = responseApi.messageAlert;
      isLoading = false;
      if(responseApi.ok){
         // Navigator.pushNamed(context, Modular.initialRoute);
         // Modular.to.navigate("/home/dream");
         Navigator.pop(context, DreamPageDto(isRemoveDream: true, dream: dream));
      }
   }

   Future<void> changeTimeModeChart(Dream dreamSelected, bool isChartWeek) async {
      if(listHistoryYaerlyMonthDailyGoals.isEmpty){
         await _findHistoryYearlyMonthDailyGoal(dreamSelected);
      }
      _isChartWeek(isChartWeek);
   }

   void editDream(BuildContext context, Dream dreamSelected) {
      Navigator.pushNamed(context, "/home/dream/newDreamWithFocus",
          arguments: DreamPageDto(isDreamWait: dreamSelected.isDreamWait??false, dream: dreamSelected));
   }
}