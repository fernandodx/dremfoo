import 'dart:math';

import 'package:dremfoo/app/api/extensions/util_extensions.dart';
import 'package:dremfoo/app/model/video.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/contract/ishared_prefs_repository.dart';
import 'package:dremfoo/app/modules/home/domain/entities/planning_daily.dart';
import 'package:dremfoo/app/modules/home/domain/entities/task_on_day.dart';
import 'package:dremfoo/app/modules/home/domain/entities/test_free_feature.dart';
import 'package:dremfoo/app/modules/home/domain/usecases/contract/ihome_usecase.dart';
import 'package:dremfoo/app/modules/home/infra/repositories/contract/ihome_repository.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/modules/login/infra/repositories/contract/iregister_user_repository.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeUseCase implements IHomeUsecase {
  IRegisterUserRepository _userRepository;
  IHomeRepository _homeRepository;
  ISharedPrefsRepository _sharedPrefsRepository;

  HomeUseCase(this._userRepository, this._homeRepository, this._sharedPrefsRepository);

  @override
  Future<ResponseApi<UserRevo>> findCurrentUser() async {
    try {
      String uid = await _sharedPrefsRepository.getString("USER_LOG_UID");
      if (uid.isNotEmpty) {
        var _userRevo = Modular.get<UserRevo>();
        _userRevo.uid = uid;
      }

      var user = await _userRepository.findCurrentUser();
      return ResponseApi.ok(result: user);
    } on RevoExceptions catch (error) {
      var alert =
          MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(
        Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<DateTime>> findLastDayAcessForUser() async {
    try {
      var date = await _userRepository.findLastDayAcessForUser(true);
      return ResponseApi.ok(result: date);
    } on RevoExceptions catch (error) {
      var alert =
          MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
    }
    var alert = MessageAlert.create(
        Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<List<UserRevo>>> findRankUser() async {
    try {
      List<UserRevo> listRankUser = await _userRepository.findRankUser();
      return ResponseApi.ok(result: listRankUser);
    } on RevoExceptions catch (error) {
      var alert =
          MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
    }
    var alert = MessageAlert.create(
        Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<List<Video>>> findAllVideos(bool descending) async {
    try {
      List<Video> listRankUser = await _homeRepository.findAllVideos(true);
      return ResponseApi.ok(result: listRankUser);
    } on RevoExceptions catch (error) {
      var alert =
          MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
    }
    var alert = MessageAlert.create(
        Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<Video>> getRadomVideo() async {
    try {
      List<Video> listVideosFree = await _homeRepository.findAllVideos(true);
      int indexRandom = Random().nextInt(listVideosFree.length);
      return ResponseApi.ok(result: listVideosFree[indexRandom]);
    } on RevoExceptions catch (error) {
      var alert =
          MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
    }
    var alert = MessageAlert.create(
        Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  Future<ResponseApi<PlanningDaily>> findDailyPlaningForDate(DateTime date) async {
    try {
      List<PlanningDaily> listPlanning = await _homeRepository.findDailyPlaningForDate(date);
      if (listPlanning.isNotEmpty) {
        return ResponseApi.ok(result: listPlanning.first);
      } else {
        return ResponseApi.error(
            messageAlert:
                MessageAlert.create("Ops!", "Esse dia não foi planejado. Fique tranquilo , agora é planejar o próximo dia e avaliar esse.", TypeAlert.ALERT));
      }
    } on RevoExceptions catch (error) {
      var alert =
          MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
    }
    var alert = MessageAlert.create(
        Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  Future<ResponseApi<PlanningDaily>> saveOrUpdateRateDayForPlanningDaily(
      PlanningDaily planningDaily) async {
    try {
      PlanningDaily planning =
          await _homeRepository.saveOrUpdateRateDayForPlanningDaily(planningDaily);
      return ResponseApi.ok(
          result: planning,
          messageAlert: MessageAlert.create(Translate.i().get.label_rating_saved,
              Translate.i().get.msg_rating_saved, TypeAlert.SUCESS));
    } on RevoExceptions catch (error) {
      var alert =
          MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
    }
    var alert = MessageAlert.create(
        Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<PlanningDaily>> saveOrUpdatePrepareNextDayForPlanningDaily(
      PlanningDaily planningDaily) async {
    try {
      PlanningDaily planning =
          await _homeRepository.saveOrUpdatePrepareNextDayForPlanningDaily(planningDaily);
      return ResponseApi.ok(
          result: planning,
          messageAlert: MessageAlert.create(
            Translate.i().get.label_day_prepared_saved,
            Translate.i().get.msg_day_prepared_saved,
            TypeAlert.SUCESS,
          ));
    } on RevoExceptions catch (error) {
      var alert =
          MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
    }
    var alert = MessageAlert.create(
        Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<TaskOnDay>> updateTask(TaskOnDay task) async {
    try {
      TaskOnDay taskUpdate = await _homeRepository.updateTask(task);
      return ResponseApi.ok(
          result: taskUpdate,
         );
    } on RevoExceptions catch (error) {
      var alert =
      MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
    }
    var alert = MessageAlert.create(
        Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<TestFreeFeature?>> findTestFreeFeature(TestFreeFeature testFreeFeature) async {

    try {
      List<TestFreeFeature> listTestFreeFeature = await _homeRepository.findTestFreeFeature(testFreeFeature);
      if (listTestFreeFeature.isNotEmpty) {
        return ResponseApi.ok(result: listTestFreeFeature.first);
      } else {
        return ResponseApi.ok(result: null);
      }
    } on RevoExceptions catch (error) {
      var alert =
      MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
    }
    var alert = MessageAlert.create(
        Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<TestFreeFeature>> saveTestFreeFeature(TestFreeFeature testFreeFeature) async {
    try {
      TestFreeFeature testFeature = await _homeRepository.saveTestFreeFeature(testFreeFeature);
      return ResponseApi.ok(result: testFeature,);
    } on RevoExceptions catch (error) {
      var alert =
      MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
    }
    var alert = MessageAlert.create(
        Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }
}
