import 'package:cloud_firestore/cloud_firestore.dart';

class DailyGratitude {

  String? gratitude;
  DocumentReference? reference;

  DailyGratitude({this.gratitude, this.reference});

  DailyGratitude.fromMap(Map<String, dynamic> map) {
    gratitude = map["gratitude"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["gratitude"] = this.gratitude;
    return map;
  }

  static List<DailyGratitude> fromListDocumentSnapshot(List<QueryDocumentSnapshot> list){
    return list.map((snapshot) {
      DailyGratitude dailyGratitude = DailyGratitude.fromMap(snapshot.data() as Map<String, dynamic>);
      dailyGratitude.reference = snapshot.reference;
      return dailyGratitude;
    }).toList();
  }
}