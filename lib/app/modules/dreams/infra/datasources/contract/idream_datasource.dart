
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/color_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';

abstract class IDreamDatasource {

  Future<List<Dream>> findAllDreamForUser(String fireBaseUserUid);

  Future<List<StepDream>> findAllStepsForDream(String userUid, String uidDream);

  Future<List<DailyGoal>> findAllDailyGoalForDream(String userUid, String uidDream);

  Future<void> updateDailyGoal(DailyGoal dailyGoal);

  Future<void> updateStepDream(StepDream stepDream);

  Future<void> registerHistoryDailyGoal(DailyGoal dailyGoal);

  Future<void> deleteRegisterHistoryDailyGoalforDate(DailyGoal dailyGoal, DateTime dateDelete);

  Future<List<DailyGoal>> findIntervalHistoryDailyGoal(Dream dream, Timestamp dateStart, Timestamp dateEnd);

  Future<List<ColorDream>> findAllColorsDream();

  Future<Dream> saveDream(Dream dream, String userUid);

  Future<Dream> updateDream(Dream dream);

  Future<List<Dream>> findAllDreamsArchive(String uidUser);

  Future<void> updateOnlyFieldDream(Dream dream, String field, dynamic value);

  Future<List<Dream>> findAllDreamsCompleted(String uidUser);

}