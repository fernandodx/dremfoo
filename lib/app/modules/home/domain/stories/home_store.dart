import 'dart:async';

import 'package:dremfoo/app/model/video.dart';
import 'package:dremfoo/app/modules/core/config/app_purchase.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/utils/ad_util.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dtos/period_report_dto.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/status_dream_week.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/contract/i_report_dream_case.dart';
import 'package:dremfoo/app/modules/home/domain/usecases/contract/ihome_usecase.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/contract/ilogin_case.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/contract/iregister_user_case.dart';
import 'package:dremfoo/app/utils/date_util.dart';
import 'package:dremfoo/app/utils/notification_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store {
  IHomeUsecase _homeUsecase;
  IRegisterUserCase _registerUserCase;
  ILoginCase _loginCase;
  IReportDreamCase _reportDreamCase;

  _HomeStoreBase(this._homeUsecase, this._registerUserCase, this._loginCase, this._reportDreamCase);

  @observable
  MessageAlert? msgAlert;

  @observable
  UserRevo? currentUser;

  @observable
  DateTime? lastDateAcess;

  @observable
  Video? video;

  @observable
  List<UserRevo> listRankUser = ObservableList<UserRevo>();

  @observable
  bool isBannerAdReady = false;

  BannerAd? bannerAd;

  Future<void> fetch(BuildContext context) async {
    NotificationUtil.deleteNotificationChannel(NotificationUtil.CHANNEL_NOTIFICATION_DAILY);
    await _findCurrentUser();
    ResponseApi<UserRevo> responseUserLevel = await _registerUserCase.checkLevelFocusUser();
    if (responseUserLevel.ok) {
      currentUser = responseUserLevel.result;
    }
    await _registerUserCase.updateCountAcess();
    await _loginCase.saveLastAcessUser();
    _findLastDayAcess();
    _loadRankUser();
    _loadVideo();
    _loadBanner();
    _checkReportGoals(context);
  }

  void _loadBanner() {
    bannerAd = BannerAd(
      adUnitId: AdUtil.bannerDashboardId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isBannerAdReady = true;
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    bannerAd!.load();
  }

  Future<void> _checkReportGoals(BuildContext context) async {
    bool isReportWeek = await _checkReportGoalsWeek(context);
    if(!isReportWeek){
      _checkReportGoalsMonth(context);
    }
  }

  Future<bool> _checkReportGoalsMonth(BuildContext context) async {

    DateTime now = DateTime.now();
    int year = now.year;
    int lastMonth = now.month - 1;

    if (lastMonth == 0) {
      lastMonth = 12;
      year = year - 1;
    }

    ResponseApi<List<StatusDreamPeriod>> responseApiStatusMonth =
        await _reportDreamCase.findStatusDreamWithMonth(lastMonth, year);
    if (responseApiStatusMonth.ok && responseApiStatusMonth.result?.isEmpty == true) {
      navigatePageReportDream(context,
          numberPeriod: lastMonth, periodStatus: PeriodStatusDream.MONTHLY, year: year);
      return true;
    }
    return false;
  }

  Future<bool> _checkReportGoalsWeek(BuildContext context) async {

    DateTime now = DateTime.now();
    int lastWeekCheckGoals = DateUtil().getLastWeek(now.month, now.day, now.year);

    ResponseApi<List<StatusDreamPeriod>> responseApiStatus =
    await _reportDreamCase.findStatusDreamWithWeek(lastWeekCheckGoals, now.year);
    if (responseApiStatus.ok && responseApiStatus.result?.isEmpty == true) {
      navigatePageReportDream(context,
          numberPeriod: lastWeekCheckGoals, periodStatus: PeriodStatusDream.WEEKLY, year: now.year);
      return true;
    }
    return false;
  }

  @action
  Future<void> _findCurrentUser() async {
    ResponseApi<UserRevo> responseApi = await _homeUsecase.findCurrentUser();
    msgAlert = responseApi.messageAlert;
    if (responseApi.ok) {
      UserRevo _user = responseApi.result!;
      this.currentUser = _user;
    }
  }

  @action
  Future<void> _findLastDayAcess() async {
    ResponseApi<DateTime> responseApi = await _homeUsecase.findLastDayAcessForUser();
    msgAlert = responseApi.messageAlert;
    if (responseApi.ok) {
      DateTime _date = responseApi.result!;
      this.lastDateAcess = _date;
    }
  }

  @action
  Future<void> _loadRankUser() async {
    ResponseApi<List<UserRevo>> responseApi = await _homeUsecase.findRankUser();
    msgAlert = responseApi.messageAlert;
    if (responseApi.ok) {
      List<UserRevo> _listRank = responseApi.result!;
      this.listRankUser = ObservableList.of(_listRank);
    }
  }

  @action
  Future<void> _loadVideo() async {
    ResponseApi<Video> responseApi = await _homeUsecase.getRadomVideo();
    msgAlert = responseApi.messageAlert;
    if (responseApi.ok) {
      this.video = responseApi.result;
    }
  }

  String get postionRankFormat {
    int index = listRankUser.indexWhere((rankUser) => rankUser.email == currentUser?.email);
    if (index >= 0) {
      return "Posição: ${index + 1}˚";
    }
    return "Sem posição";
  }

  void navigateArchivePage(BuildContext context) {
    Navigator.pushNamed(context, "/dream/archive");
  }

  void navigateDreamsCompletedPage(BuildContext context) {
    Navigator.pushNamed(context, "/dream/dreamsCompleted");
  }

  void navigateSocialNetworkPage(BuildContext context) {
    Navigator.pushNamed(context, "/socialNetwork");
  }

  void navigatePageFreeVideos(BuildContext context) {
    Navigator.pushNamed(context, "/freeVideos");
  }

  void navigatePageReportDream(BuildContext context,
      {required int numberPeriod,
      required PeriodStatusDream periodStatus,
      required int year}) {
    Navigator.pushNamed(context, "/dream/reportDreamWeek",
        arguments: PeriodReportDto(
            numPeriod: numberPeriod,
            periodStatus: periodStatus,
            year: year));
  }
}
