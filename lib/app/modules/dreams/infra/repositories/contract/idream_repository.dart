import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';

abstract class IDreamRepository {

  Future<List<Dream>> findAllDreamForUser();

  Future<List<StepDream>> findAllStepsForDream(String uidDream);

  Future<List<DailyGoal>> findAllDailyGoalForDream(String uidDream);

  Future<void> updateDailyGoal(DailyGoal dailyGoal);

  Future<void> updateStepDream(StepDream stepDream);

  Future<void> registerHistoryDailyGoal(DailyGoal dailyGoal);

  Future<void> deleteRegisterHistoryDailyGoalforDate(DailyGoal dailyGoal, DateTime dateDelete);

  Future<List<DailyGoal>> findIntervalHistoryDailyGoal(Dream dream, DateTime dateStart, DateTime dateEnd);


}