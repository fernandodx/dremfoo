import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/config/app_purchase.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/home/domain/entities/test_free_feature.dart';
import 'package:dremfoo/app/modules/home/domain/usecases/home_usecase.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../utils/analytics_util.dart';
import '../../../core/domain/entities/response_api.dart';

part 'presentation_daily_planning_store.g.dart';

class PresentationDailyPlanningStore = _PresentationDailyPlanningStoreBase
    with _$PresentationDailyPlanningStore;

abstract class _PresentationDailyPlanningStoreBase with Store {
  HomeUseCase _homeUseCase;

  _PresentationDailyPlanningStoreBase(this._homeUseCase);

  late TestFreeFeature testFreeFeature;
  late AppPurchase appPurchase;

  @observable
  bool isLoading = false;

  @observable
  MessageAlert? msgAlert;

  @observable
  bool isPeriodFreeFinish = false;

  void fetch(BuildContext context) async {

    appPurchase = Modular.get<AppPurchase>();

    if (appPurchase.isEnableSubscription) {
      Navigator.pushReplacementNamed(
        context,
        "/home/dailyPlanning",
      );
      return;
    }

    testFreeFeature = TestFreeFeature(
      dateInit: Timestamp.now(),
      idFeature: "br.com.dias.dremfoo.daily.planning",
      qtdDays: 7,
    );

    isLoading = true;
    ResponseApi<TestFreeFeature?> responseApi =
        await _homeUseCase.findTestFreeFeature(testFreeFeature);
    isLoading = false;
    if (responseApi.ok) {
      TestFreeFeature? testFreeFound = responseApi.result;

      if (testFreeFound != null) {
        DateTime dateFinish = testFreeFound.dateInit!.toDate().add(Duration(days: testFreeFound.qtdDays!));
        DateTime now = DateTime.now();

        if (now.isBefore(dateFinish)) {
          Navigator.pushReplacementNamed(
            context,
            "/home/dailyPlanning",
          );
        } else {
          isPeriodFreeFinish = true;
          msgAlert = MessageAlert.create(
              Translate.i().get.title_trial_test_end,
              Translate.i().get.msg_trial_test_end,
              TypeAlert.ALERT);
        }
      }
    } else {
      msgAlert = responseApi.messageAlert;
    }
  }

  Future<void> initTestFree(BuildContext context) async {
    isLoading = true;
    ResponseApi<TestFreeFeature> responseApi =
        await _homeUseCase.saveTestFreeFeature(testFreeFeature);
    isLoading = false;
    if (responseApi.ok) {
      AnalyticsUtil.sendAnalyticsEvent(EventRevo.startTrial7daysDailyPlanning);
      TestFreeFeature testFreeFeature = responseApi.result!;
      Navigator.pushReplacementNamed(
        context,
        "/home/dailyPlanning",
      );
    } else {
      msgAlert = responseApi.messageAlert;
    }
  }
}
