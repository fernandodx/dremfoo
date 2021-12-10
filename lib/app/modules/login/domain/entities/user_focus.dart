import 'package:cloud_firestore/cloud_firestore.dart';

import 'level_revo.dart';

class UserFocus {

  Timestamp? dateInit;
  Timestamp? dateLastFocus;
  int? countDaysFocus;
  DocumentReference? reference;
  LevelRevo? level;

  UserFocus();

  UserFocus.fromMap(Map<String, dynamic>? map) {
    if(map != null){
      dateInit = map["dateInit"];
      dateLastFocus = map["dateLastFocus"];
      countDaysFocus = map["countDaysFocus"];
      level = map["level"] != null ? LevelRevo.fromMap(map["level"]) : null;
    }
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["dateInit"] = this.dateInit;
    map["dateLastFocus"] = this.dateLastFocus;
    map["countDaysFocus"] = this.countDaysFocus;
    map["level"] = this.level != null ? this.level!.toMap() : null;
    return map;
  }

  static List<UserFocus> fromListDocumentSnapshot(List<QueryDocumentSnapshot> list){
    return list.map((snapshot) {
      UserFocus userFocus = UserFocus.fromMap(snapshot.data() as Map<String, dynamic>?);
      userFocus.reference = snapshot.reference;
      return userFocus;
    }).toList();
  }


}