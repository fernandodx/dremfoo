import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/domain/utils/analytics_util.dart';
import 'package:dremfoo/app/modules/core/domain/utils/revo_analytics.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/color_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/infra/datasources/contract/idream_datasource.dart';
import 'package:dremfoo/app/modules/dreams/infra/repositories/contract/idream_repository.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DreamRespository extends IDreamRepository {

  IDreamDatasource _datasource;
  DreamRespository(this._datasource);

  var _userRevo = Modular.get<UserRevo>();

  @override
  Future<List<Dream>> findAllDreamForUser() async {
   try{

     if(_userRevo.uid != null){
      return _datasource.findAllDreamForUser(_userRevo.uid!);
     }else{
       RevoExceptions _revoExceptions = new RevoExceptions
           .msgToUser(error: Exception("userRevo.uid == null"), msg: "Login não encontrado!");
       CrashlyticsUtil.logError(_revoExceptions);
       throw _revoExceptions;
     }

   } catch(error, stack) {
     CrashlyticsUtil.logErro(error, stack);
     throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
   }

  }

  @override
  Future<List<DailyGoal>> findAllDailyGoalForDream(String uidDream) {
    try{

      if(_userRevo.uid != null){
        return _datasource.findAllDailyGoalForDream(_userRevo.uid!, uidDream);
      }else{
        RevoExceptions _revoExceptions = new RevoExceptions
            .msgToUser(error: Exception("userRevo.uid == null"), msg: "Login não encontrado!");
        CrashlyticsUtil.logError(_revoExceptions);
        throw _revoExceptions;
      }

    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  @override
  Future<List<StepDream>> findAllStepsForDream(String uidDream) {
    try{

      if(_userRevo.uid != null){
        return _datasource.findAllStepsForDream(_userRevo.uid!, uidDream);
      }else{
        RevoExceptions _revoExceptions = new RevoExceptions
            .msgToUser(error: Exception("userRevo.uid == null"), msg: "Login não encontrado!");
        CrashlyticsUtil.logError(_revoExceptions);
        throw _revoExceptions;
      }

    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  Future<void> updateDailyGoal(DailyGoal dailyGoal) async {
    try{
      await _datasource.updateDailyGoal(dailyGoal);
      //validar referencias
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  Future<void> registerHistoryDailyGoal(DailyGoal dailyGoal) async {
    try{

      if(dailyGoal.reference.parent.parent == null ){
        // return erro
      }

     await _datasource.registerHistoryDailyGoal(dailyGoal);
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  Future<void> deleteRegisterHistoryDailyGoalforDate(DailyGoal dailyGoal, DateTime dateDelete) async {
    try{

      if(dailyGoal.reference.parent.parent == null ){
        // return erro
      }

      await _datasource.deleteRegisterHistoryDailyGoalforDate(dailyGoal, dateDelete);
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  Future<void> updateStepDream(StepDream stepDream) async {
    try{
      stepDream.isCompleted = stepDream.dateCompleted != null;
      await _datasource.updateStepDream(stepDream);
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  @override
  Future<List<DailyGoal>> findIntervalHistoryDailyGoal(Dream dream, DateTime dateStart, DateTime dateEnd) async {
   try{
     Timestamp start = Timestamp.fromDate(dateStart);
     Timestamp end = Timestamp.fromDate(dateEnd);
     return _datasource.findIntervalHistoryDailyGoal(dream, start, end);
   } catch(error, stack) {
     CrashlyticsUtil.logErro(error, stack);
     throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
   }
  }

  @override
  Future<List<ColorDream>> findAllColorsDream() async {
    try{
      return _datasource.findAllColorsDream();
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  @override
  Future<Dream> saveDream(Dream dream) async {
    try{
      dream.dateRegister = Timestamp.now();

      if(_userRevo.uid != null){
        AnalyticsUtil.sendAnalyticsEvent(EventRevo.newDream);
        return _datasource.saveDream(dream, _userRevo.uid!);
      }else{
        RevoExceptions _revoExceptions = new RevoExceptions
            .msgToUser(error: Exception("userRevo.uid == null"), msg: "Login não encontrado!");
        CrashlyticsUtil.logError(_revoExceptions);
        throw _revoExceptions;
      }



    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  @override
  Future<Dream> updateDream(Dream dream) {
    try{
      if(dream.reference != null){
        return _datasource.updateDream(dream);
      }else{
        RevoExceptions _revoExceptions = new RevoExceptions
            .msgToUser(error: Exception("DreamReference == null"), msg: "Sonho não encontrado para a atualização.");
        CrashlyticsUtil.logError(_revoExceptions);
        throw _revoExceptions;
      }
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }


  Future<List<Dream>> findAllDreamsArchiveCurrentUser() async {
    try{

      if(_userRevo.uid != null){
        return _datasource.findAllDreamsArchive(_userRevo.uid!);
      }else{
        RevoExceptions _revoExceptions = new RevoExceptions
            .msgToUser(error: Exception("userRevo.uid == null"), msg: "Login não encontrado!");
        CrashlyticsUtil.logError(_revoExceptions);
        throw _revoExceptions;
      }

    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  @override
  Future<void> updateArchiveDream(Dream dream, {required bool isArchived}) async {
    try{
      _datasource.updateOnlyFieldDream(dream, "isDeleted", isArchived);
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  @override
  Future<void> updateRealizedDream(Dream dream, {required DateTime? dateFinish}) async {
    try{
      _datasource.updateOnlyFieldDream(dream, "dateFinish",
          dateFinish != null ? Timestamp.fromDate(dateFinish) : null);
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  @override
  Future<List<Dream>> findAllDreamsCompletedCurrentUser() async {
    try{
      if(_userRevo.uid != null){
        return _datasource.findAllDreamsCompleted(_userRevo.uid!);
      }else{
        RevoExceptions _revoExceptions = new RevoExceptions
            .msgToUser(error: Exception("userRevo.uid == null"), msg: "Login não encontrado!");
        CrashlyticsUtil.logError(_revoExceptions);
        throw _revoExceptions;
      }
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }







}