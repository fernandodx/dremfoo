import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/color_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';

abstract class IDreamCase {

  Future<ResponseApi<List<Dream>>> findDreamsForUser();

  Future<ResponseApi<List<StepDream>>> findStepDreamForUser(String uidDream);

  Future<ResponseApi<List<DailyGoal>>> findDailyGoalForUser(String uidDream);

  Future<ResponseApi> updateDailyGoalDream(DailyGoal dailyGoal, DateTime currentDate);

  Future<ResponseApi> updateStepDream(StepDream stepDream);

  Future<ResponseApi<List<DailyGoal>>> findHistoryDailyGoalCurrentDate(Dream dream, DateTime date);

  Future<ResponseApi<List<DailyGoal>>> findHistoryDailyGoalCurrentWeek(Dream dream, DateTime date);

  Future<ResponseApi<List<DailyGoal>>> findHistoryDailyGoalCurrentYearlyMonth(Dream dream, DateTime date);

  Future<ResponseApi<String>> loadImageDreamGallery();

  Future<ResponseApi<List<ColorDream>>> findAllColorsDream();

  Future<ResponseApi<Dream>> saveDream(Dream dream);

  Future<ResponseApi<Dream>> updateDream(Dream dream);


}