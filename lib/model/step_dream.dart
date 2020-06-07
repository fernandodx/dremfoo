import 'package:cloud_firestore/cloud_firestore.dart';

class StepDream {

  String uid;
  String dreamPropose;
  String step;
  int position;
  int color;
  bool isCompleted = false;
  Timestamp dateCompleted;
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StepDream &&
              runtimeType == other.runtimeType &&
              step == other.step;

  @override
  int get hashCode => step.hashCode;






}