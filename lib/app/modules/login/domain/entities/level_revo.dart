import 'package:cloud_firestore/cloud_firestore.dart';

class LevelRevo {

  int? countDaysFocus;
  int? position;
  int? finishValue;
  int? initValue;
  String? name;
  String? urlIcon;
  DocumentReference? reference;

  LevelRevo();

  LevelRevo.fromMap(Map<String, dynamic> map) {
    position = map["position"];
    finishValue = map["finishValue"];
    initValue = map["initValue"];
    name = map["name"];
    urlIcon = map["urlIcon"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["position"] = this.position;
    map["finishValue"] = this.finishValue;
    map['initValue'] = this.initValue;
    map["name"] = this.name;
    map["urlIcon"] = this.urlIcon;
    return map;
  }

  static List<LevelRevo> fromListDocumentSnapshot(List<QueryDocumentSnapshot> list){
    return list.map((snapshot) {
      LevelRevo level = LevelRevo.fromMap(snapshot.data() as Map<String, dynamic>);
      level.reference = snapshot.reference;
      return level;
    }).toList();
  }


}