import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmDream {

  String? uid;
  bool isActive = false;
  Timestamp? time;
  bool isSunday = false;
  bool isMonday = false;
  bool isTuesday = false;
  bool isWednesday = false;
  bool isThursday = false;
  bool isFriday = false;
  bool isSaturdays = false;
  late DocumentReference reference;


  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['isActive'] = this.isActive;
    data['time'] = this.time;
    data['isSunday'] = this.isSunday;
    data['isMonday'] = this.isMonday;
    data['isTuesday'] = this.isTuesday;
    data['isWednesday'] = this.isWednesday;
    data['isThursday'] = this.isThursday;
    data['isFriday'] = this.isFriday;
    data['isSaturdays'] = this.isSaturdays;
    return data;
  }

  static AlarmDream fromMap(data){
    AlarmDream alarm = AlarmDream();
    if(data != null){
      alarm.uid = data['uid'];
      alarm.isActive = data['isActive'];
      alarm.time = data['time'];
      alarm.isSunday = data['isSunday'];
      alarm.isMonday = data['isMonday'];
      alarm.isTuesday = data['isTuesday'];
      alarm.isWednesday = data['isWednesday'];
      alarm.isThursday = data['isThursday'];
      alarm.isFriday = data['isFriday'];
      alarm.isSaturdays = data['isSaturdays'];
    }

    return alarm;
  }

  static List<AlarmDream> fromListDocumentSnapshot(List<QueryDocumentSnapshot> list){
    return list.map((snapshot) {
      AlarmDream alarm = fromMap(snapshot.data());
      alarm.reference = snapshot.reference;
      alarm.uid = snapshot.id;
      return alarm;
    }).toList();
  }



}