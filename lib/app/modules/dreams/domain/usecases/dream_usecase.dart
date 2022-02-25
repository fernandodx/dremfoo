import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/core/domain/utils/analytics_util.dart';
import 'package:dremfoo/app/modules/core/domain/utils/revo_analytics.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/contract/iupload_image_repository.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/color_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/contract/idream_case.dart';
import 'package:dremfoo/app/modules/dreams/infra/repositories/contract/idream_repository.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:dremfoo/app/api/extensions/util_extensions.dart';
import 'package:dremfoo/app/utils/date_util.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DreamUseCase extends IDreamCase {

  IDreamRepository _repository;
  IUploadImageRepository _imageRepository;
  DreamUseCase(this._repository, this._imageRepository);

  @override
  Future<ResponseApi<List<Dream>>> findDreamsForUser() async {

    try{

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

  void _validateDream(Dream dream) {
    StringBuffer msgError = StringBuffer();

    if(dream.isDreamWait == false) {
      if(dream.steps == null || dream.steps!.isEmpty){
        msgError.writeln("Os passos do sonho são obrigatórios");
      }
      if(dream.dailyGoals == null || dream.dailyGoals!.isEmpty){
        msgError.writeln("As metas diárias são obrigatórios");
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

      var dreamUpdate = await _repository.updateDream(dream);
      return ResponseApi.ok(result: dreamUpdate);

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