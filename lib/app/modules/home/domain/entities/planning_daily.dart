import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/home/domain/entities/prepare_next_day.dart';
import 'package:dremfoo/app/modules/home/domain/entities/rate_day_planning.dart';

import 'daily_gratitude.dart';
import 'prevent_on_day.dart';
import 'task_on_day.dart';

class PlanningDaily {

  Timestamp? date;
  RateDayPlanning? rateDayPlanning;
  PrepareNextDay? prepareNextDay;
  DocumentReference? reference;
  List<DailyGratitude>? listGraditude;
  List<PreventOnDay>? listPreventDay;
  List<TaskOnDay>? listTaskDay;


  PlanningDaily({this.date, this.rateDayPlanning, this.prepareNextDay, this.listGraditude, this.listPreventDay, this.listTaskDay, this.reference});

  PlanningDaily.fromMap(Map<String, dynamic> map) {
    date = map["date"];
    rateDayPlanning = map["rateDayPlanning"] != null ? RateDayPlanning.fromMap(map["rateDayPlanning"]) : null;
    prepareNextDay = map["prepareNextDay"] != null ? PrepareNextDay.fromMap(map["prepareNextDay"]) : null;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["date"] = this.date;
    map["rateDayPlanning"] = this.rateDayPlanning?.toMap();
    map["prepareNextDay"] = this.prepareNextDay?.toMap();
    return map;
  }

  static List<PlanningDaily> fromListDocumentSnapshot(List<QueryDocumentSnapshot> list){
    return list.map((snapshot) {
      PlanningDaily pLanningDaily = PlanningDaily.fromMap(snapshot.data() as Map<String, dynamic>);
      pLanningDaily.reference = snapshot.reference;
      return pLanningDaily;
    }).toList();
  }






}