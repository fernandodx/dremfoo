
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/home/domain/entities/daily_gratitude.dart';
import 'package:dremfoo/app/modules/home/domain/entities/planning_daily.dart';
import 'package:dremfoo/app/modules/home/domain/entities/rate_day_planning.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

import '../usecases/contract/ihome_usecase.dart';

part 'rate_of_the_day_store.g.dart';

class RateOfTheDayStore = _RateOfTheDayStoreBase with _$RateOfTheDayStore;

abstract class _RateOfTheDayStoreBase with Store {

  IHomeUsecase _homeUsecase;
  _RateOfTheDayStoreBase(this._homeUsecase);

  @observable
  bool isLoading = false;

  @observable
  MessageAlert? msgAlert;

  @observable
  double currentValueRateDay = 0;

  @observable
  double levelLearning = 0;

  TextEditingController commentTextController = TextEditingController();
  TextEditingController gratitude1TextController = TextEditingController();
  TextEditingController gratitude2TextController = TextEditingController();
  TextEditingController gratitude3TextController = TextEditingController();

  late RateDayPlanning rateDayPlanning;

  void featch() {
    rateDayPlanning = RateDayPlanning();
  }


  @action
  void setCurrentValueRateDay(double value){
    this.currentValueRateDay = value;
  }

  @action
  void setLevelLearning(double value){
    this.levelLearning = value;
  }

  void saveRateDay(DateTime dateSelected) async {

    var gratitude1 = gratitude1TextController.text;
    var gratitude2 = gratitude2TextController.text;
    var gratitude3 = gratitude3TextController.text;

    if(gratitude1.isEmpty || gratitude2.isEmpty || gratitude3.isEmpty){
      msgAlert = MessageAlert.create("Ops!", Translate.i().get.msg_erro_rate_the_day, TypeAlert.ALERT);
      return;
    }

    List<DailyGratitude> listGraditude = [
      DailyGratitude(gratitude: gratitude1),
      DailyGratitude(gratitude: gratitude2),
      DailyGratitude(gratitude: gratitude3),
    ];

    rateDayPlanning = RateDayPlanning(
      rateDay: currentValueRateDay,
      levelLearningDay: levelLearning,
      commentLearningDaily: commentTextController.text,
    );
    
    
    ResponseApi<PlanningDaily> responseApi = await  _homeUsecase.saveOrUpdateRateDayForPlanningDaily(PlanningDaily(
      date: Timestamp.fromDate(dateSelected),
      rateDayPlanning: rateDayPlanning,
      listGraditude: listGraditude,
    ));

    msgAlert = responseApi.messageAlert;

  }


}