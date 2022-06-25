import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/api/extensions/util_extensions.dart';
import 'package:dremfoo/app/modules/home/domain/entities/daily_gratitude.dart';
import 'package:dremfoo/app/modules/home/domain/entities/planning_daily.dart';
import 'package:dremfoo/app/modules/home/domain/entities/prevent_on_day.dart';
import 'package:dremfoo/app/modules/home/domain/usecases/contract/ihome_usecase.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:mobx/mobx.dart';

import '../../../core/domain/entities/error_msg.dart';
import '../../../core/domain/entities/response_api.dart';
import '../entities/task_on_day.dart';

part 'daily_planning_store.g.dart';

class DailyPlanningStore = _DailyPlanningStoreBase with _$DailyPlanningStore;

abstract class _DailyPlanningStoreBase with Store {

  IHomeUsecase _homeUsecase;
  _DailyPlanningStoreBase(this._homeUsecase);

  @observable
  DateTime datePlanning = DateTime.now().subtract(Duration(days: 1));

  @observable
  bool isLoading = false;

  @observable
  MessageAlert? msgAlert;

  @observable
  PlanningDaily? planningDaily;

  @observable
  List<DailyGratitude> listGratitude = ObservableList<DailyGratitude>();

  @observable
  List<PreventOnDay> listPrevent = ObservableList<PreventOnDay>();

  @observable
  List<TaskOnDay> listTask = ObservableList<TaskOnDay>();


  @computed
  String get labelDatePlanning {
    var dateTime = Timestamp.fromDate(datePlanning);
    return dateTime.toDate().add(Duration(days: 1)).formatExtension();
  }

  @computed
  bool get isShowAnalysisDay {
    var date = Timestamp.fromDate(datePlanning).toDate().add(Duration(days: 1));
    var now = DateTime.now();
    return planningDaily?.rateDayPlanning != null && now.day != date.day;
  }

  void fetch() async {

    isLoading = true;
    ResponseApi<PlanningDaily> responseApi =  await _homeUsecase.findDailyPlaningForDate(datePlanning);
    isLoading = false;
    msgAlert = responseApi.messageAlert;
    if(responseApi.ok){
      PlanningDaily planningDaily = responseApi.result!;

      setPlanningDaily(planningDaily);

      if(planningDaily.listGraditude != null){
        setListGratitude(planningDaily.listGraditude!);
      }
      if(planningDaily.listPreventDay != null) {
        setListPrevent(planningDaily.listPreventDay!);
      }
      if(planningDaily.listTaskDay != null){
        setListTask(planningDaily.listTaskDay!);
      }
    }else{
      setPlanningDaily(null);
      setListGratitude([]);
      setListTask([]);
      setListPrevent([]);
    }
  }

  String getDateNow() {
    return datePlanning.formatExtension();
  }

  String getLabelRateDay() {
    DateTime dateNow = DateTime.now();
    var timestampDailyPLannig = Timestamp.fromDate(datePlanning);
    var dateTimeDailyPLannig = timestampDailyPLannig.toDate().add(Duration(days: 1));
    if(dateTimeDailyPLannig.day != dateNow.day){
      return "${Translate.i().get.label_evaluate_day} ${datePlanning.format()}";
    }else{
      return Translate.i().get.label_rate_my_day;
    }
  }

  String getLabelPrepareNextDay() {
    DateTime dateNow = DateTime.now();
    var timestampDailyPLannig = Timestamp.fromDate(datePlanning);
    var dateTimeDailyPLannig = timestampDailyPLannig.toDate().add(Duration(days: 1));
    if(dateTimeDailyPLannig.day != dateNow.day){
      return "${Translate.i().get.label_plan_day} ${timestampDailyPLannig.toDate().add(Duration(days: 1)).format()}";
    }else{
      return Translate.i().get.label_plan_next_day;
    }
  }

  DateTime getDateForPrepareNextDayAndRateDay() {
    DateTime dateNow = DateTime.now();
    var timestampDailyPLannig = Timestamp.fromDate(datePlanning);
    var dateTimeDailyPLannig = timestampDailyPLannig.toDate().add(Duration(days: 1));
    if(dateTimeDailyPLannig.day != dateNow.day){
      return dateTimeDailyPLannig;
    }else{
      return dateNow;
    }
  }


  Future<void> onUpdateListTask(bool isCompleted, TaskOnDay task) async {

    var index = listTask.indexWhere((item) => item.task == task.task);

    List<TaskOnDay> newList = [];
    newList.addAll(listTask);

    if(isCompleted){
      task.dateCompleted = Timestamp.now();
    }else{
      task.dateCompleted = null;
    }

    ResponseApi<TaskOnDay> taskUpdate = await  _homeUsecase.updateTask(task);
    msgAlert = taskUpdate.messageAlert;
    if(taskUpdate.ok){
      newList[index] = taskUpdate.result!;
      setListTask(newList);
    }

  }


  @action
  void setListTask(List<TaskOnDay> tasks) {
    this.listTask = tasks;
  }

  @action
  void setListPrevent(List<PreventOnDay> prevents) {
    this.listPrevent = prevents;
  }

  @action
  void setListGratitude(List<DailyGratitude> gratitudes) {
    this.listGratitude = gratitudes;
  }

  @action
  void setPlanningDaily(PlanningDaily? planningDaily) {
    this.planningDaily = planningDaily;
  }

  void updateDatePlannig(DateTime date) {
    datePlanning = date;
    fetch();
  }

  void nextDayPlanning(){
    var nextDay = datePlanning.add(Duration(days: 1));
    updateDatePlannig(nextDay);
  }

  void backDayPlanning() {
    var backDay = datePlanning.subtract(Duration(days: 1));
    updateDatePlannig(backDay);
  }








}