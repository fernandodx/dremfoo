import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:dremfoo/app/model/dream.dart';

class StepDream {

  String uid;
  String step;
  int position;
  int color;
  bool isCompleted = false;
  Timestamp dateCompleted;
  Dream dreamParent;
  DocumentReference reference;

//  Set<StatusDream> statusDream = Set();

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['step'] = this.step;
    data['position'] = this.position;
    data['color'] = this.color;
    data['isCompleted'] = this.isCompleted;
    data['dateCompleted'] = this.dateCompleted;

//    data['statusDream'] = this.statusDream;
    return data;
  }

  static StepDream fromMap(data){
    StepDream status = StepDream();
    status.step = data['step'];
    status.position = data['position'];
    status.color = data['color'];
    status.isCompleted = data['isCompleted'] == null ? false : data['isCompleted'];
    status.dateCompleted = data['dateCompleted'];
    return status;
  }

  static List<StepDream> fromListDocumentSnapshot(List<QueryDocumentSnapshot> list){
    return list.map((snapshot) {
      StepDream step = fromMap(snapshot.data());
      step.reference = snapshot.reference;
      step.uid = snapshot.id;
      return step;
    }).toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StepDream &&
              runtimeType == other.runtimeType &&
              step == other.step;

  @override
  int get hashCode => step.hashCode;






}