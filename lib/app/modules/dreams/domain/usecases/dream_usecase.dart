import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/contract/idream_case.dart';
import 'package:dremfoo/app/modules/dreams/infra/repositories/contract/idream_repository.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';

class DreamUseCase extends IDreamCase {

  IDreamRepository _repository;
  DreamUseCase(this._repository);

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

  Future<void> updateDailyGoalDream(DailyGoal dailyGoal) async {
    _repository.updateDailyGoal(dailyGoal);

    if(dailyGoal.lastDateCompleted != null) {
      _repository.registerHistoryDailyGoal(dailyGoal);
    }else{
      _repository.deleteRegisterHistoryDailyGoalforDate(dailyGoal, DateTime.now());
    }

  }



}