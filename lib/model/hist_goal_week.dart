import 'dart:convert' as convert;

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/model/dream.dart';


class HistGoalWeek {

  Timestamp firsDayWeek;
  int numberWeek;
  double difficulty;
  String reward;
  String inflection;
  bool isWonReward;
  bool isNeedInflection;
  bool isShow;
  Timestamp dateLastShow;
  DocumentReference reference;

  Dream dream;

  HistGoalWeek();

  HistGoalWeek.fromMap(Map<String, dynamic> map) {
    firsDayWeek = map["firsDayWeek"];
    numberWeek = map["numberWeek"];
    difficulty = map["difficulty"];
    reward = map["reward"];
    inflection = map["inflection"];
    isWonReward = map["isWonReward"];
    isNeedInflection = map["isNeedInflection"];
    isShow = map["isShow"];
    dateLastShow = map["dateLastShow"];
  }

  static List<HistGoalWeek> fromListDocumentSnapshot(List<DocumentSnapshot> list){
    return list.map((snapshot) {
      HistGoalWeek hist = HistGoalWeek.fromMap(snapshot.data());
      hist.reference = snapshot.reference;
      return hist;
    }).toList();
  }

  static List<HistGoalWeek> fromListDocumentSnapshotWithDream(List<DocumentSnapshot> list, Dream dream){
    return list.map((snapshot) {
      HistGoalWeek hist = HistGoalWeek.fromMap(snapshot.data());
      hist.reference = snapshot.reference;
      hist.dream = dream;
      return hist;
    }).toList();
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["firsDayWeek"] = this.firsDayWeek;
    map['numberWeek'] = this.numberWeek;
    map["difficulty"] = this.difficulty;
    map["reward"] = this.reward;
    map["inflection"] = this.inflection;
    map["isWonReward"] = this.isWonReward;
    map["isNeedInflection"] = this.isNeedInflection;
    map["isShow"] = this.isShow;
    map["dateLastShow"] = this.dateLastShow;
    return map;
  }

  String toJson() {
    return convert.json.encode(toMap());
  }



}