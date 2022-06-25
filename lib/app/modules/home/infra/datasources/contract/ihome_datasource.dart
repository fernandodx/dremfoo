import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/model/video.dart';
import 'package:dremfoo/app/modules/home/domain/entities/planning_daily.dart';
import 'package:dremfoo/app/modules/home/domain/entities/task_on_day.dart';

import '../../../domain/entities/test_free_feature.dart';

abstract class IHomeDatasource {

  Future<List<Video>> findAllVideos(bool descending);

  Future<PlanningDaily> saveOrUpdateRateDayForPlanningDaily(String userUid, PlanningDaily planningDaily);

  Future<PlanningDaily> saveOrUpdatePrepareNextDayForPlanningDaily(String userUid, PlanningDaily planningDaily);

  Future<List<PlanningDaily>> findDailyPlaningForDate(String userUid, Timestamp dateStart, Timestamp dateEnd);

  Future<TaskOnDay> updateTask(TaskOnDay task);

  Future<TestFreeFeature> saveTestFreeFeature(String userUid, TestFreeFeature testFreeFeature);

  Future<List<TestFreeFeature>> findTestFreeFeature(String userUid, TestFreeFeature testFreeFeature);


}