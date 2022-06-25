import 'package:cloud_firestore/cloud_firestore.dart';

class PrepareNextDay {

  String? focusDay;
  DocumentReference? reference;

  PrepareNextDay({this.focusDay, this.reference});

  PrepareNextDay.fromMap(Map<String, dynamic> map) {
    focusDay = map["focusDay"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["focusDay"] = this.focusDay;
    return map;
  }

  static List<PrepareNextDay> fromListDocumentSnapshot(List<QueryDocumentSnapshot> list){
    return list.map((snapshot) {
      PrepareNextDay task = PrepareNextDay.fromMap(snapshot.data() as Map<String, dynamic>);
      task.reference = snapshot.reference;
      return task;
    }).toList();
  }




}