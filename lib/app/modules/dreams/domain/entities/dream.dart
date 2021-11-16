import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/color_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';


class Dream {

  String? uid;
  String? dreamPropose;
  String? descriptionPropose;
  String? imgDream;
  String? reward;
  String? rewardWeek;
  String? inflection;
  String? inflectionWeek;
  double? goalWeek = 25;
  double? goalMonth = 25;
  bool? isGoalWeekOk = false;
  bool? isGoalMonthOk = false;
  bool? isRewardWeek = false;
  bool? isInflectionWeek = false;
  bool? isDeleted = false;
  bool? isDreamWait = false;
  ColorDream? color;
  Timestamp? dateRegister;
  Timestamp? dateFinish;
  List<StepDream>? steps = [];
  List<DailyGoal>? dailyGoals = [];
  List<DailyGoal>? listHistoryWeekDailyGoals = [];
  DocumentReference? reference;

  static Dream copy(Dream data){
    Dream dream = Dream();
    dream.dreamPropose = data.dreamPropose;
    dream.descriptionPropose = data.descriptionPropose;
    dream.imgDream = data.imgDream;
    dream.reward = data.reward;
    dream.inflection = data.inflection;
    dream.dreamPropose = data.dreamPropose;
    dream.steps = data.steps;
    dream.dailyGoals = data.dailyGoals;
    dream.dateRegister = data.dateRegister;
    dream.dateFinish = data.dateFinish;
    dream.reference = data.reference;
    dream.uid = data.uid;
    dream.goalWeek = data.goalWeek;
    dream.goalMonth = data.goalMonth;
    dream.isGoalWeekOk = data.isGoalWeekOk;
    dream.isGoalMonthOk = data.isGoalMonthOk;
    dream.isInflectionWeek = data.isInflectionWeek;
    dream.isRewardWeek = data.isRewardWeek;
    dream.inflectionWeek = data.inflectionWeek;
    dream.rewardWeek = data.rewardWeek;
    dream.isDeleted = data.isDeleted;
    dream.color = data.color;
    dream.isDreamWait = data.isDreamWait;
    dream.listHistoryWeekDailyGoals = data.listHistoryWeekDailyGoals;
    return dream;
  }

  static Dream fromMap(data){
    Dream dream = Dream();
    dream.dreamPropose = data['dreamPropose'];
    dream.descriptionPropose = data['descriptionPropose'];
    dream.imgDream = data['imgDream'];
    dream.reward = data['reward'];
    dream.inflection = data['inflection'];
    dream.dreamPropose = data['dreamPropose'];
    dream.dateRegister = data['dateRegister'];
    dream.dateFinish = data['dateFinish'];
    dream.goalWeek = data['goalWeek'];
    dream.goalMonth = data['goalMonth'];
    dream.isGoalWeekOk = data['isGoalWeekOk'];
    dream.isGoalMonthOk = data['isGoalMonthOk'];
    dream.isInflectionWeek = data['isInflectionWeek'];
    dream.isRewardWeek = data['isRewardWeek'];
    dream.inflectionWeek = data['inflectionWeek'];
    dream.rewardWeek = data['rewardWeek'];
    dream.isDeleted = data['isDeleted'];
    dream.isDreamWait = data['isDreamWait'];
    dream.color = ColorDream.fromMap(data['color']);
    return dream;
  }

  static List<Dream> fromListDocumentSnapshot(List<QueryDocumentSnapshot> list){
    return list.map((snapshot) {
       Dream dream = Dream.fromMap(snapshot.data());
       dream.reference = snapshot.reference;
       dream.uid = snapshot.id;
       return dream;
    }).toList();
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dreamPropose'] = this.dreamPropose;
    data['descriptionPropose'] = this.descriptionPropose;
    data['imgDream'] = this.imgDream;
    data['reward'] = this.reward;
    data['inflection'] = this.inflection;
    data['dreamPropose'] = this.dreamPropose;
    data['dateRegister'] = this.dateRegister;
    data['goalWeek'] = this.goalWeek;
    data['goalMonth'] = this.goalMonth;
    data['isGoalWeekOk'] = this.isGoalWeekOk;
    data['isGoalMonthOk'] = this.isGoalMonthOk;
    data['isInflectionWeek'] = this.isInflectionWeek;
    data['isRewardWeek'] = this.isRewardWeek;
    data['inflectionWeek'] = this.inflectionWeek;
    data['rewardWeek'] = this.rewardWeek;
    data['isDeleted'] = this.isDeleted;
    data['color'] = this.color!.toMap();
    data['isDreamWait'] = this.isDreamWait;
    data['dateFinish'] = this.dateFinish;
//    data['steps'] = this.steps;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dream && runtimeType == other.runtimeType && uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}