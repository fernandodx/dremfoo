import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/model/daily_goal.dart';
import 'package:dremfoo/model/step_dream.dart';

class Dream {

  String uid;
  String dreamPropose;
  String descriptionPropose;
  String imgDream;
  String reward;
  String inflection;
  String colorHex;
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
    return dream;
  }

  static Dream fromMap(data){
    Dream dream = Dream();
    dream.dreamPropose = data['dreamPropose'];
    dream.descriptionPropose = data['descriptionPropose'];
    dream.imgDream = data['imgDream'];
    dream.reward = data['reward'];
    dream.inflection = data['inflection'];
    dream.colorHex = data['colorHex'] != null ? data['colorHex'] : "F0C808";
    dream.dreamPropose = data['dreamPropose'];
    dream.dateRegister = data['dateRegister'];
    return dream;
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
//    data['steps'] = this.steps;
    return data;
  }




//  String toJson() {
//    String json = convert.json.encode(toMap());
//    return json;
//  }


}