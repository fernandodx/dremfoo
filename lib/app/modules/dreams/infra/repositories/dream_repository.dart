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
       return _datasource.findAllDreamForUser("7uFOlj8el2Q62sblZxu7jnWaRME3");
       // RevoExceptions _revoExceptions = new RevoExceptions
       //     .msgToUser(error: Exception("userRevo.uid == null"), msg: "Login não encontrado!");
       // CrashlyticsUtil.logError(_revoExceptions);
       // throw _revoExceptions;
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
        return _datasource.findAllDailyGoalForDream("7uFOlj8el2Q62sblZxu7jnWaRME3", uidDream);
        // RevoExceptions _revoExceptions = new RevoExceptions
        //     .msgToUser(error: Exception("userRevo.uid == null"), msg: "Login não encontrado!");
        // CrashlyticsUtil.logError(_revoExceptions);
        // throw _revoExceptions;
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
        return _datasource.findAllStepsForDream("7uFOlj8el2Q62sblZxu7jnWaRME3", uidDream);
        // RevoExceptions _revoExceptions = new RevoExceptions
        //     .msgToUser(error: Exception("userRevo.uid == null"), msg: "Login não encontrado!");
        // CrashlyticsUtil.logError(_revoExceptions);
        // throw _revoExceptions;
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





}