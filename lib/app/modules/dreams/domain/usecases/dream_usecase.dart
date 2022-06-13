import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/core/domain/utils/analytics_util.dart';
import 'package:dremfoo/app/modules/core/domain/utils/revo_analytics.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/contract/ishared_prefs_repository.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/contract/iupload_image_repository.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/color_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/contract/idream_case.dart';
import 'package:dremfoo/app/modules/dreams/infra/repositories/contract/idream_repository.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/modules/login/infra/repositories/contract/iregister_user_repository.dart';
import 'package:dremfoo/app/resources/constants.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:dremfoo/app/api/extensions/util_extensions.dart';
import 'package:dremfoo/app/utils/date_util.dart';
import 'package:dremfoo/app/utils/notification_util.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DreamUseCase extends IDreamCase {

  IDreamRepository _repository;
  ISharedPrefsRepository _sharedPrefsRepository;
  IUploadImageRepository _imageRepository;
  IRegisterUserRepository _userRepository;
  DreamUseCase(this._repository, this._imageRepository, this._sharedPrefsRepository, this._userRepository);

  @override
  Future<ResponseApi<List<Dream>>> findDreamsForUser() async {

    try{
      await findCurrentUser();
      List<Dream> listDream = await _repository.findAllDreamForUser();
      return ResponseApi.ok(result: listDream);

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }


  @override
  Future<ResponseApi<UserRevo>> findCurrentUser() async {
    try{

      String uid = await _sharedPrefsRepository.getString("USER_LOG_UID");
      if(uid.isNotEmpty){
        var _userRevo = Modular.get<UserRevo>();
        _userRevo.uid = uid;
      }

      var user = await _userRepository.findCurrentUser();
      return ResponseApi.ok(result: user);

    }on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<List<DailyGoal>>> findDailyGoalForUser(String uidDream) async {
    try{

      List<DailyGoal> listDaily = await _repository.findAllDailyGoalForDream(uidDream);
      return ResponseApi.ok(result: listDaily);

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<List<StepDream>>> findStepDreamForUser(String uidDream) async {
    try{

      List<StepDream> listStep = await _repository.findAllStepsForDream(uidDream);
      return ResponseApi.ok(result: listStep);

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi> updateStepDream(StepDream stepDream) async {
    try{
      await _repository.updateStepDream(stepDream);
      return ResponseApi.ok();

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi> updateDailyGoalDream(DailyGoal dailyGoal, DateTime currentDate) async {

    try{

      if(dailyGoal.lastDateCompleted == null
          || dailyGoal.lastDateCompleted!.toDate().isSameDate(DateTime.now())){
        await _repository.updateDailyGoal(dailyGoal);
      }

      if(dailyGoal.lastDateCompleted != null) {
        await _repository.registerHistoryDailyGoal(dailyGoal);
      }else{
        await _repository.deleteRegisterHistoryDailyGoalforDate(dailyGoal, currentDate);
      }

      return ResponseApi.ok();

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);

  }

  @override
  Future<ResponseApi<List<DailyGoal>>> findHistoryDailyGoalCurrentDate(Dream dream, DateTime date) async {
    try{
      List<DailyGoal> listHist = await _repository.findIntervalHistoryDailyGoal(dream, Utils.resetStartDay(date), Utils.resetEndDay(date));
      return ResponseApi.ok(result: listHist);
    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<List<DailyGoal>>> findHistoryDailyGoalCurrentWeek(Dream dream, DateTime date, {bool isIgnoreSunday = false}) async {
    try{

      DateTime firstDay = date.subtract(Duration(days: date.weekday));
      DateTime endDay = firstDay.add(Duration(days: 7));

      if(!isIgnoreSunday && date.weekday == DateTime.sunday) {
        firstDay = date;
        endDay = date;
      }

      List<DailyGoal> listHist = await _repository.findIntervalHistoryDailyGoal(dream, Utils.resetStartDay(firstDay), Utils.resetEndDay(endDay));
      return ResponseApi.ok(result: listHist);
    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<List<DailyGoal>>> findHistoryDailyGoalCurrentYearlyMonth(Dream dream, DateTime date) async {
    try{
      DateTime firstDay = DateTime(date.year, 1,1); //01/01/2021
      DateTime endDay = DateTime(date.year, 12,31); //31/01/2021

      List<DailyGoal> listHist = await _repository.findIntervalHistoryDailyGoal(dream, Utils.resetStartDay(firstDay), Utils.resetEndDay(endDay));
      return ResponseApi.ok(result: listHist);
    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<List<DailyGoal>>> findHistoryDailyGoalCurrentMonth(Dream dream, int month , int year) async {
    try{
      DateTime firstDay = DateTime(year, month,1);
      DateTime endDay = DateTime(year, month,31);

      List<DailyGoal> listHist = await _repository.findIntervalHistoryDailyGoal(dream, Utils.resetStartDay(firstDay), Utils.resetEndDay(endDay));
      return ResponseApi.ok(result: listHist);
    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<String>> loadImageDreamGallery() async {
    try{

      File img = await _imageRepository.chooseImageGallery(maxWidth: 300, imageQuality: 90);
      List<int> imageBytes = img.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      AnalyticsUtil.sendAnalyticsEvent(EventRevo.addImageDream);
      return ResponseApi.ok(result: base64Image);

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<List<ColorDream>>> findAllColorsDream() async {
    try{

      List<ColorDream> listColors = await _repository.findAllColorsDream();
      if(listColors.isNotEmpty){
        return ResponseApi.ok(result: listColors);
      }

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<Dream>> saveDream(Dream dream) async {
    try{

      _validateDream(dream);
      await _saveUpdadeNotifyAlarm(dream);

      var dreamSave = await _repository.saveDream(dream);
      return ResponseApi.ok(result: dreamSave);

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  Future<void> _saveUpdadeNotifyAlarm(Dream dream) async {
    var now = DateTime.now();
    var dateAlarm = dream.alarm?.time?.toDate() ?? now;

    for(int weekID = 1; weekID <= 7; weekID++){
      await NotificationUtil.cancelNotification(weekID*99);
    }

    if(dream.alarm?.isActive == false){
      return;
    }

    for(int weekID = 1; weekID <= 7; weekID++){

      switch(weekID) {
        case DateTime.sunday:
          var isActive = dream.alarm?.isSunday??false;
          await _processNotifyDream(isActive, now, weekID, dateAlarm, dream);
          break;
        case DateTime.monday:
          var isActive = dream.alarm?.isMonday??false;
          await _processNotifyDream(isActive, now, weekID, dateAlarm, dream);
          break;
        case DateTime.tuesday:
          var isActive = dream.alarm?.isTuesday??false;
          await _processNotifyDream(isActive, now, weekID, dateAlarm, dream);
          break;
        case DateTime.wednesday:
          var isActive = dream.alarm?.isWednesday??false;
          await _processNotifyDream(isActive, now, weekID, dateAlarm, dream);
          break;
        case DateTime.thursday:
          var isActive = dream.alarm?.isThursday??false;
          await _processNotifyDream(isActive, now, weekID, dateAlarm, dream);
          break;
        case DateTime.friday:
          var isActive = dream.alarm?.isFriday??false;
          await _processNotifyDream(isActive, now, weekID, dateAlarm, dream);
          break;
        case DateTime.saturday:
          var isActive = dream.alarm?.isSaturdays??false;
          await _processNotifyDream(isActive, now, weekID, dateAlarm, dream);
          break;
      }
    }
  }

  Future<void> _processNotifyDream(bool isActive, DateTime now, int weekID, DateTime dateAlarm, Dream dream) async {
    if(isActive){
      await notifyWeekIDDream(now, weekID, dateAlarm, dream);
    }else{
      NotificationUtil.cancelNotification(weekID);
    }
  }

  Future<void> notifyWeekIDDream(DateTime now, int weekID, DateTime dateAlarm, Dream dream) async {
    int weekday =  now.weekday;
    int diff = weekday - weekID;
    if(diff > 0){
      dateAlarm = now.subtract(Duration(days: diff));
    }if(diff < 0){
      dateAlarm = now.add(Duration(days: diff * -1));
    }
    await NotificationUtil.showDailyAtDateTime(
         weekID*99,
        "Seu sonho ${dream.dreamPropose}, esta te esperando!",
        "${dream.descriptionPropose}",
        dateAlarm,
        NotificationUtil.ID_NOTIFICATION_DAILY,
        NotificationUtil.CHANNEL_NOTIFICATION_DAILY,
        NotificationUtil.DESCRIPTION_NOTIFICATION_DAILY,
        matchTime: DateTimeComponents.dayOfWeekAndTime);
  }

  void _validateDream(Dream dream) {
    StringBuffer msgError = StringBuffer();

    if(dream.isDreamWait == false) {
      if(dream.steps == null || dream.steps!.isEmpty){
        msgError.writeln("Os passos do sonho são obrigatórios");
      }
      if(dream.dailyGoals == null || dream.dailyGoals!.isEmpty){
        msgError.writeln("As metas diárias são obrigatórios");
      }
      if(dream.alarm?.isActive == true){
        if(dream.alarm?.time == null){
          msgError.writeln("É necessário definir um horário no alarme");
        }
      }

      if(msgError.isNotEmpty){
        throw RevoExceptions.msgToUser(msg: msgError.toString());
      }
    }
  }

  @override
  Future<ResponseApi<Dream>> updateDream(Dream dream) async {
    try{

      //TODO fazer metodo unico
      _validateDream(dream);
      await _saveUpdadeNotifyAlarm(dream);

      var dreamUpdate = await _repository.updateDream(dream);
      return ResponseApi.ok(result: dreamUpdate);

      // await NotificationUtil.cancelNotification(1001);
      //
      // DateTime time = DateTime.now();
      // time = time.add(Duration(seconds: 60));
      //
      // //teste
      // await NotificationUtil.showDailyAtDateTime(
      //     1001,
      //     "Chegou TESTE! Seu sonho ${dream.dreamPropose} esta te esperando.",
      //     "${dream.descriptionPropose}",
      //     time,
      //     NotificationUtil.ID_NOTIFICATION_DAILY,
      //     NotificationUtil.CHANNEL_NOTIFICATION_DAILY,
      //     NotificationUtil.DESCRIPTION_NOTIFICATION_DAILY,
      //     matchTime: DateTimeComponents.dayOfWeekAndTime);

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi> archiveDream(Dream dream) async {
    try{
      await _repository.updateArchiveDream(dream, isArchived: true);
      return ResponseApi.ok();
    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi> realizedDream(Dream dream,  {required DateTime? dateFinish}) async {
    try{
      await _repository.updateRealizedDream(dream, dateFinish: dateFinish);
      return ResponseApi.ok();
    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<List<Dream>>> findAllDreamsArchive() async {
    try{

      await findCurrentUser();
      List<Dream> listeDream = await _repository.findAllDreamsArchiveCurrentUser();
      return ResponseApi.ok(result: listeDream);

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi> restoreDream(Dream dream) async {
    try{
      await _repository.updateArchiveDream(dream, isArchived: false);
      return ResponseApi.ok();
    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<List<Dream>>> findAllDreamsCompletedCurrentUser() async {
    try{

      await findCurrentUser();
      List<Dream> listeDream = await _repository.findAllDreamsCompletedCurrentUser();
      return ResponseApi.ok(result: listeDream);

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<Dream>> updatePercentsGoalsDream(Dream dream) async {
    try{

     Dream dreamResp = await _repository.updatePercentsGoalsDream(dream);
     return ResponseApi.ok(result: dreamResp);

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<Dream>> updatePercentsGoalsAndSteps(Dream dream) async {
    try{

      double? percentToday = 0;
      double? percentStep = 0;

      percentStep = _countPercentStep(dream.steps);
      percentToday = _countPercentToday(dream.listHistoryWeekDailyGoals, dream.dailyGoals);

      dream.percentStep = percentStep;
      dream.percentToday = percentToday;

      var _userRevo = Modular.get<UserRevo>();
      _userRevo.focus?.dateLastFocus = Timestamp.now();

      var response = await updatePercentsGoalsDream(dream);
      return response;

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  double _countPercentStep(List<StepDream>? listStep) {
    double percentStep = 0;
    int countStep = 0;
    int countStepCompleted = 0;

    if(listStep != null){
      countStep = listStep.length;
      countStepCompleted = listStep
          .where((step) => step.isCompleted??false).toList().length;

      if(countStepCompleted > 0 && countStep > 0){
        percentStep = countStepCompleted / countStep;
      }
    }
    return percentStep;
  }

  @override
  bool checkPercentIsToday() {
    var _userRevo = Modular.get<UserRevo>();
    if(_userRevo.focus?.dateLastFocus != null
        && !_userRevo.focus!.dateLastFocus!.toDate().isSameDate(DateTime.now())){
      return false;
    }
    return true;
  }

  double _countPercentToday(List<DailyGoal>? listHistoryWeekDailyGoals, List<DailyGoal>? listDaily) {
    double percentToday = 0;
    int countDailyToday = 0;
    int countDaily = 0;

    if(listDaily != null) {
      countDaily = listDaily.length;
    }

    if(listHistoryWeekDailyGoals != null && listHistoryWeekDailyGoals.length > 0){
      countDailyToday = listHistoryWeekDailyGoals
          .where((daily) => daily.lastDateCompleted!.toDate().isSameDate(DateTime.now()))
          .toList().length;

      if(countDailyToday > 0 && countDaily > 0) {
        percentToday = countDailyToday / countDaily;
      }
    }
    return percentToday;
  }








}