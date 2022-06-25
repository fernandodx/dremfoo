import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/home/domain/entities/daily_gratitude.dart';

class RateDayPlanning {

  double? rateDay;
  double? levelLearningDay;
  String? commentLearningDaily;
  DocumentReference? reference;

  RateDayPlanning({this.rateDay, this.levelLearningDay,  this.commentLearningDaily, this.reference});

  RateDayPlanning.fromMap(Map<String, dynamic> map) {
    rateDay = map["rateDay"];
    levelLearningDay = map["levelLearningDay"];
    commentLearningDaily = map["commentLearningDaily"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["rateDay"] = this.rateDay;
    map["levelLearningDay"] = this.levelLearningDay;
    map["commentLearningDaily"] = this.commentLearningDaily;
    return map;
  }

  static List<RateDayPlanning> fromListDocumentSnapshot(List<QueryDocumentSnapshot> list){
    return list.map((snapshot) {
      RateDayPlanning rateDay = RateDayPlanning.fromMap(snapshot.data() as Map<String, dynamic>);
      rateDay.reference = snapshot.reference;
      return rateDay;
    }).toList();
  }
}