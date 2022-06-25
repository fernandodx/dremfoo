import 'package:dremfoo/app/model/video.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';

import '../../entities/planning_daily.dart';
import '../../entities/task_on_day.dart';
import '../../entities/test_free_feature.dart';

abstract class IHomeUsecase {

  Future<ResponseApi<UserRevo>> findCurrentUser();

  Future<ResponseApi<DateTime>> findLastDayAcessForUser();

  Future<ResponseApi<List<UserRevo>>> findRankUser();

  Future<ResponseApi<List<Video>>> findAllVideos(bool descending);

  Future<ResponseApi<Video>> getRadomVideo();

  Future<ResponseApi<PlanningDaily>> saveOrUpdateRateDayForPlanningDaily(PlanningDaily planningDaily);

  Future<ResponseApi<PlanningDaily>> saveOrUpdatePrepareNextDayForPlanningDaily(PlanningDaily planningDaily);

  Future<ResponseApi<PlanningDaily>> findDailyPlaningForDate(DateTime date);

  Future<ResponseApi<TaskOnDay>> updateTask(TaskOnDay task);

  Future<ResponseApi<TestFreeFeature>> saveTestFreeFeature(TestFreeFeature testFreeFeature);

  Future<ResponseApi<TestFreeFeature?>> findTestFreeFeature(TestFreeFeature testFreeFeature);


}