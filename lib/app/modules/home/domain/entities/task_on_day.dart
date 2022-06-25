import 'package:cloud_firestore/cloud_firestore.dart';

class TaskOnDay {

  String? task;
  Timestamp? dateCompleted;
  DocumentReference? reference;

  TaskOnDay({this.task, this.dateCompleted, this.reference});

  TaskOnDay.fromMap(Map<String, dynamic> map) {
    task = map["task"];
    dateCompleted = map["dateCompleted"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["task"] = this.task;
    map["dateCompleted"] = this.dateCompleted;
    return map;
  }

  static List<TaskOnDay> fromListDocumentSnapshot(List<QueryDocumentSnapshot> list){
    return list.map((snapshot) {
      TaskOnDay task = TaskOnDay.fromMap(snapshot.data() as Map<String, dynamic>);
      task.reference = snapshot.reference;
      return task;
    }).toList();
  }

  bool isChecked() {
    return dateCompleted != null;
  }


}