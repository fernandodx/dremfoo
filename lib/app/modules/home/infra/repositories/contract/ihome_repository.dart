import 'package:dremfoo/app/model/video.dart';
import 'package:dremfoo/app/modules/home/domain/entities/planning_daily.dart';
import 'package:dremfoo/app/modules/home/domain/entities/task_on_day.dart';

import '../../../domain/entities/test_free_feature.dart';

abstract class IHomeRepository {

  Future<List<Video>> findAllVideos(bool descending);

  Future<PlanningDaily> saveOrUpdateRateDayForPlanningDaily(PlanningDaily planningDaily);

  Future<PlanningDaily> saveOrUpdatePrepareNextDayForPlanningDaily(PlanningDaily planningDaily);

  Future<List<PlanningDaily>> findDailyPlaningForDate(DateTime date);

  Future<TaskOnDay> updateTask(TaskOnDay task);

  Future<TestFreeFeature> saveTestFreeFeature(TestFreeFeature testFreeFeature);

  Future<List<TestFreeFeature>> findTestFreeFeature(TestFreeFeature testFreeFeature);
  
}