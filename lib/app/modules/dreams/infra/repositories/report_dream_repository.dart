import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/status_dream_week.dart';
import 'package:dremfoo/app/modules/dreams/infra/datasources/contract/ireport_dream_datasource.dart';
import 'package:dremfoo/app/modules/dreams/infra/repositories/contract/ireport_dream_repository.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../login/infra/repositories/contract/iregister_user_repository.dart';

class ReportDreamRepository implements IReportDreamRepository {

  IReportDreamDataSource _dataSource;
  ReportDreamRepository(this._dataSource);

  @override
  Future<List<StatusDreamPeriod>> findStatusDreamWithWeek(int numberWeek, int year) async {

    try{
      var _userRevo = Modular.get<UserRevo>();

      if(_userRevo.uid != null){
        return await _dataSource.findStatusDreamWithWeek(_userRevo.uid!, numberWeek, year);
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
  Future<List<StatusDreamPeriod>> findStatusDreamWithMonth(int numberMonth, int year) async  {
    try{
      var _userRevo = Modular.get<UserRevo>();

      if(_userRevo.uid != null){
        return await _dataSource.findStatusDreamWithMonth(_userRevo.uid!, numberMonth, year);
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
  Future<void> saveStatusDreamWithWeek(StatusDreamPeriod period) async {
    try{
      var _userRevo = Modular.get<UserRevo>();

      if(_userRevo.uid != null){
        return await _dataSource.saveStatusDreamWithWeek(_userRevo.uid!, period);
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
  Future<void> saveStatusDreamWithMonth(StatusDreamPeriod period) async {
    try{
      var _userRevo = Modular.get<UserRevo>();

      if(_userRevo.uid != null){
        return await _dataSource.saveStatusDreamWithMonth(_userRevo.uid!, period);
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
  Future<List<StatusDreamPeriod>> findAllStatusDreamMonth() async  {
    try{
      var _userRevo = Modular.get<UserRevo>();

      if(_userRevo.uid != null){
        return await _dataSource.findAllStatusDreamMonth(_userRevo.uid!);
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
  Future<List<StatusDreamPeriod>> findAllStatusDreamWeek() async {
    try{
      var _userRevo = Modular.get<UserRevo>();

      if(_userRevo.uid != null){
        return await _dataSource.findAllStatusDreamWeek(_userRevo.uid!);
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
  Future<void> updateStatusDreamPeriod(StatusDreamPeriod status) {
    try{

      if(status.reference != null){
        return _dataSource.updateStatusDreamPeriod(status);
      }else{
        RevoExceptions _revoExceptions = new RevoExceptions
            .msgToUser(error: Exception("StatusDreamPeriod.reference == null"), msg: "Referencia não encontrada!");
        CrashlyticsUtil.logError(_revoExceptions);
        throw _revoExceptions;
      }

    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }






}