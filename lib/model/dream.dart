import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/model/daily_goal.dart';
import 'package:dremfoo/model/step_dream.dart';

class Dream {

  String uid;
  String dreamPropose;
  String descriptionPropose;
  String imgDream;
  String reward;
  String rewardWeek;
  String inflection;
  String inflectionWeek;
  String colorHex;
  double goalWeek = 0;
  double goalMonth = 0;
  bool isGoalWeekOk = false;
  bool isGoalMonthOk = false;
  bool isRewardWeek = false;
  bool isInflectionWeek = false;
  Timestamp dateRegister;
  List<StepDream> steps = List();
  List<DailyGoal> dailyGoals = List();
  DocumentReference reference;

  static Dream copy(Dream data){
    Dream dream = Dream();
    dream.dreamPropose = data.dreamPropose;
    dream.descriptionPropose = data.descriptionPropose;
    dream.imgDream = data.imgDream;
    dream.reward = data.reward;
    dream.inflection = data.inflection;
    dream.colorHex = data.colorHex;
    dream.dreamPropose = data.dreamPropose;
    dream.steps = data.steps;
    dream.dailyGoals = data.dailyGoals;
    dream.dateRegister = data.dateRegister;
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
    return dream;
  }

  static Dream fromMap(data){
    Dream dream = Dream();
    dream.dreamPropose = data['dreamPropose'];
    dream.descriptionPropose = data['descriptionPropose'];
    dream.imgDream = data['imgDream'];
    dream.reward = data['reward'];
    dream.inflection = data['inflection'];
    dream.colorHex = data['colorHex'];
    dream.dreamPropose = data['dreamPropose'];
    dream.dateRegister = data['dateRegister'];
    dream.goalWeek = data['goalWeek'];
    dream.goalMonth = data['goalMonth'];
    dream.isGoalWeekOk = data['isGoalWeekOk'];
    dream.isGoalMonthOk = data['isGoalMonthOk'];
    dream.isInflectionWeek = data['isInflectionWeek'];
    dream.isRewardWeek = data['isRewardWeek'];
    dream.inflectionWeek = data['inflectionWeek'];
    dream.rewardWeek = data['rewardWeek'];
    return dream;
  }

  static List<Dream> fromListDocumentSnapshot(List<DocumentSnapshot> list){
    return list.map((snapshot) {
       Dream dream = Dream.fromMap(snapshot.data);
       dream.reference = snapshot.reference;
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
    data['colorHex'] = this.colorHex;
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
//    data['steps'] = this.steps;
    return data;
  }




//  String toJson() {
//    String json = convert.json.encode(toMap());
//    return json;
//  }


}