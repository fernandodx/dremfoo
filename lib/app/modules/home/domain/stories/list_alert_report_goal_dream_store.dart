
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
  List<StatusDreamPeriod> listStatusPeriod = ObservableList.of([]);


  @action
  void updateItemStatusPeriodIsExpanded(int index, bool isExpanded) {
    List<StatusDreamPeriod> updateList = listStatusPeriod.toList();
    updateList[index].isExpanded = !isExpanded;
    listStatusPeriod = ObservableList.of(updateList);
  }


  Future<void> featch() async {

    _findAllReportGoalsWeek();

  }


  void open(BuildContext context) {
    Navigator.pushNamed(context, "/notificationListGoals");
  }


  Future<void> _findAllReportGoalsWeek() async {
    ResponseApi<List<StatusDreamPeriod>> responseApiStatus = await _reportDreamCase.findAllStatusDreamWeek();
    if (responseApiStatus.ok) {
      listStatusPeriod = ObservableList.of(responseApiStatus.result!);
    }
  }


}