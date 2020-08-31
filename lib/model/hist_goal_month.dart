import 'dart:convert' as convert;

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/model/dream.dart';


class HistGoalMonth {

  Timestamp dateCompleted;
  int numberMonth;
  double difficulty;
  String reward;
  String inflection;
  bool isWonReward;
  bool isNeedInflection;
  bool isShow;
  DocumentReference reference;
  Dream dream;

  HistGoalMonth();

  HistGoalMonth.fromMap(Map<String, dynamic> map) {
    dateCompleted = map["dateCompleted"];
    numberMonth = map["numberMonth"];
    difficulty = map["difficulty"];
    reward = map["reward"];
    inflection = map["inflection"];
    isWonReward = map["isWonReward"];
    isNeedInflection = map["isNeedInflection"];
    isShow = map["isShow"];
  }

  static List<HistGoalMonth> fromListDocumentSnapshot(List<DocumentSnapshot> list){
    return list.map((snapshot) {
      HistGoalMonth hist = HistGoalMonth.fromMap(snapshot.data());
      hist.reference = snapshot.reference;
      return hist;
    }).toList();
  }

  static List<HistGoalMonth> fromListDocumentWithDreamSnapshot(List<DocumentSnapshot> list, Dream dream){
    return list.map((snapshot) {
      HistGoalMonth hist = HistGoalMonth.fromMap(snapshot.data());
      hist.reference = snapshot.reference;
      hist.dream = dream;
      return hist;
    }).toList();
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['dateCompleted'] = this.dateCompleted;
    map['numberMonth'] = this.numberMonth;
    map["difficulty"] = this.difficulty;
    map["reward"] = this.reward;
    map["inflection"] = this.inflection;
    map["isWonReward"] = this.isWonReward;
    map["isNeedInflection"] = this.isNeedInflection;
    map["isShow"] = this.isShow;
    return map;
  }

  String toJson() {
    return convert.json.encode(toMap());
  }



}