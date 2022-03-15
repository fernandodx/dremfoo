
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/status_dream_week.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/contract/i_report_dream_case.dart';
import 'package:dremfoo/app/utils/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'list_alert_report_goal_dream_store.g.dart';

class ListAlertReportGoalDreamStore = _ListAlertReportGoalDreamStoreBase with _$ListAlertReportGoalDreamStore;

abstract class _ListAlertReportGoalDreamStoreBase with Store {

  IReportDreamCase _reportDreamCase;
  _ListAlertReportGoalDreamStoreBase(this._reportDreamCase);

  int initialIndex = 0;

  @observable
  bool isLoading = false;

  @observable
  MessageAlert? msgAlert;

  @observable
  List<StatusDreamPeriod> listStatusInflectionPeriod = ObservableList.of([]);

  @observable
  List<StatusDreamPeriod> listStatusRewardPeriod = ObservableList.of([]);


  @action
  void updateItemStatusInflectionPeriodIsExpanded(int index, bool isExpanded) {
    List<StatusDreamPeriod> updateList = listStatusInflectionPeriod.toList();
    updateList[index].isExpanded = !isExpanded;
    listStatusInflectionPeriod = ObservableList.of(updateList);
  }

  @action
  void updateItemStatusRewardPeriodIsExpanded(int index, bool isExpanded) {
    List<StatusDreamPeriod> updateList = listStatusRewardPeriod.toList();
    updateList[index].isExpanded = !isExpanded;
    listStatusRewardPeriod = ObservableList.of(updateList);
  }

  @action
  Future<void> updateReportStatusInflectionPeriod(bool isChecked, StatusDreamPeriod period) async {
    var newListStatus = listStatusInflectionPeriod.toList();
    var index = newListStatus.indexWhere((statusPeriod) => statusPeriod.uid == period.uid);
    period.isChecked = isChecked;
    newListStatus[index] = period;
    listStatusInflectionPeriod = ObservableList.of(newListStatus);

    ResponseApi responseApi = await _reportDreamCase.updateStatusDreamPeriod(period);
    msgAlert = responseApi.messageAlert;
  }

  @action
  Future<void> updateReportStatusRewardPeriod(bool isChecked, StatusDreamPeriod period) async {
    var newListStatus = listStatusRewardPeriod.toList();
    var index = newListStatus.indexWhere((statusPeriod) => statusPeriod.uid == period.uid);
    period.isChecked = isChecked;
    newListStatus[index] = period;
    listStatusRewardPeriod = ObservableList.of(newListStatus);

    ResponseApi responseApi = await _reportDreamCase.updateStatusDreamPeriod(period);
    msgAlert = responseApi.messageAlert;
  }


  Future<void> featch() async {

    _findAllReportGoalsWeek();

  }


  void open(BuildContext context) {
    Navigator.pushNamed(context, "/notificationListGoals");
  }


  Future<void> _findAllReportGoalsWeek() async {
    isLoading = true;
    ResponseApi<List<StatusDreamPeriod>> responseApiStatus = await _reportDreamCase.findAllStatusDreamWeek();
    if (responseApiStatus.ok) {
      var listAllStatusPeriod = responseApiStatus.result!;

      var listInflection = listAllStatusPeriod.where((period) => period.typeStatusDream == TypeStatusDream.INFLECTION).toList();
      var listReward = listAllStatusPeriod.where((period) => period.typeStatusDream == TypeStatusDream.REWARD).toList();

      listStatusInflectionPeriod = ObservableList.of(listInflection);
      listStatusRewardPeriod = ObservableList.of(listReward);
    }
    isLoading = false;
  }




}