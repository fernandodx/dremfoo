import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/home/domain/entities/planning_daily.dart';
import 'package:dremfoo/app/modules/home/domain/entities/prepare_next_day.dart';
import 'package:dremfoo/app/modules/home/domain/entities/prevent_on_day.dart';
import 'package:dremfoo/app/modules/home/domain/entities/task_on_day.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobx/mobx.dart';

import '../usecases/contract/ihome_usecase.dart';

part 'prepare_next_day_store.g.dart';

class PrepareNextDayStore = _PrepareNextDayStoreBase with _$PrepareNextDayStore;

abstract class _PrepareNextDayStoreBase with Store {

  IHomeUsecase _homeUsecase;
  _PrepareNextDayStoreBase(this._homeUsecase);

  TextEditingController focusDayTextController = TextEditingController();
  TextEditingController prevendDayTextController = TextEditingController();
  TextEditingController task1TextController = TextEditingController();
  TextEditingController task2TextController = TextEditingController();
  TextEditingController task3TextController = TextEditingController();
  TextEditingController task4TextController = TextEditingController();
  TextEditingController task5TextController = TextEditingController();

  @observable
  bool isLoading = false;

  @observable
  MessageAlert? msgAlert;


  void saveDayPrepared(BuildContext context, DateTime dateSelected) async {

    if(focusDayTextController.text.isEmpty) {
      msgAlert = MessageAlert.create("Ops!", Translate.i().get.msg_erro_focus_is_null, TypeAlert.ALERT);
      return;
    }

    if(prevendDayTextController.text.isEmpty){
      msgAlert = MessageAlert.create("Ops!", Translate.i().get.msg_erro_prevent_is_null, TypeAlert.ALERT);
      return;
    }

    var task1 = task1TextController.text;
    var task2 = task2TextController.text;
    var task3 = task3TextController.text;
    var task4 = task4TextController.text;
    var task5 = task5TextController.text;

    if(task1.isEmpty && task2.isEmpty && task3.isEmpty && task4.isEmpty && task5.isEmpty){
      msgAlert = MessageAlert.create("Ops!", Translate.i().get.msg_erro_tasks_is_null, TypeAlert.ALERT);
      return;
    }


    isLoading = true;
    ResponseApi<PlanningDaily> responseApi = await _homeUsecase.saveOrUpdatePrepareNextDayForPlanningDaily(PlanningDaily(
      date: Timestamp.fromDate(dateSelected),
      prepareNextDay: PrepareNextDay(
        focusDay: focusDayTextController.text,
      ),
      listPreventDay: [
        PreventOnDay(prevent: prevendDayTextController.text),
      ],
      listTaskDay: [
        TaskOnDay(task: task1TextController.text),
        TaskOnDay(task: task2TextController.text),
        TaskOnDay(task: task3TextController.text),
        TaskOnDay(task: task4TextController.text),
        TaskOnDay(task: task5TextController.text),
      ]
    ));

    isLoading = false;
    msgAlert = responseApi.messageAlert;

  }


}