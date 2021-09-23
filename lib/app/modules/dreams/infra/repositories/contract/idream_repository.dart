import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';

abstract class IDreamRepository {

  Future<List<Dream>> findAllDreamForUser();

  Future<List<StepDream>> findAllStepsForDream(String uidDream);

  Future<List<DailyGoal>> findAllDailyGoalForDream(String uidDream);


}