import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/model/video.dart';
import 'package:dremfoo/app/modules/home/domain/entities/task_on_day.dart';
import 'package:dremfoo/app/modules/home/domain/entities/test_free_feature.dart';
import 'package:dremfoo/app/modules/home/infra/datasources/contract/ihome_datasource.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../utils/utils.dart';
import '../../../login/domain/entities/user_revo.dart';
import '../../domain/entities/planning_daily.dart';
import 'contract/ihome_repository.dart';

class HomeRepository implements IHomeRepository {

  IHomeDatasource _datasource;
  HomeRepository(this._datasource);

  @override
  Future<List<Video>> findAllVideos(bool descending) async  {
    try{
      return await _datasource.findAllVideos(descending);
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  Future<PlanningDaily> saveOrUpdateRateDayForPlanningDaily(PlanningDaily planningDaily) async {
    try{
      var _userRevo = Modular.get<UserRevo>();
      if(_userRevo.uid != null){
        return await _datasource.saveOrUpdateRateDayForPlanningDaily(_userRevo.uid!, planningDaily);
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

  Future<List<PlanningDaily>> findDailyPlaningForDate(DateTime date) async {
    try{
      var _userRevo = Modular.get<UserRevo>();
      if(_userRevo.uid != null){

        DateTime dateStart = Utils.resetStartDay(date);
        DateTime dateEnd = Utils.resetEndDay(date);

        return await _datasource.findDailyPlaningForDate(_userRevo.uid!, Timestamp.fromDate(dateStart),
                                                         Timestamp.fromDate(dateEnd));
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
  Future<PlanningDaily> saveOrUpdatePrepareNextDayForPlanningDaily(PlanningDaily planningDaily) async {
    try{
      var _userRevo = Modular.get<UserRevo>();
      if(_userRevo.uid != null){
        return await _datasource.saveOrUpdatePrepareNextDayForPlanningDaily(_userRevo.uid!, planningDaily);
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
  Future<TaskOnDay> updateTask(TaskOnDay task) async {
    try{
      if(task.reference != null){
        return await _datasource.updateTask(task);
      }else{
        RevoExceptions _revoExceptions = new RevoExceptions
            .msgToUser(error: Exception("task.reference == null"), msg: "Referência ao objeto não encontrado.");
        CrashlyticsUtil.logError(_revoExceptions);
        throw _revoExceptions;
      }

    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  @override
  Future<List<TestFreeFeature>> findTestFreeFeature(TestFreeFeature testFreeFeature) async {
    try{
      var _userRevo = Modular.get<UserRevo>();

      if(testFreeFeature.idFeature == null){
        RevoExceptions _revoExceptions = new RevoExceptions
            .msgToUser(error: Exception("idFeature == null"), msg: "Não foi encontrado nenhuma feature com esse id.");
        CrashlyticsUtil.logError(_revoExceptions);
        throw _revoExceptions;
      }


      if(_userRevo.uid != null){
        return await _datasource.findTestFreeFeature(_userRevo.uid!, testFreeFeature);
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
  Future<TestFreeFeature> saveTestFreeFeature(TestFreeFeature testFreeFeature) async{
    try{
      var _userRevo = Modular.get<UserRevo>();
      if(_userRevo.uid != null){
        return await _datasource.saveTestFreeFeature(_userRevo.uid!, testFreeFeature);
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