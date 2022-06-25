import 'package:cloud_firestore/cloud_firestore.dart';

class PreventOnDay {

  String? prevent;
  DocumentReference? reference;


  PreventOnDay({this.prevent, this.reference});

  PreventOnDay.fromMap(Map<String, dynamic> map) {
    prevent = map["prevent"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["prevent"] = this.prevent;
    return map;
  }

  static List<PreventOnDay> fromListDocumentSnapshot(List<QueryDocumentSnapshot> list){
    return list.map((snapshot) {
      PreventOnDay rateDay = PreventOnDay.fromMap(snapshot.data() as Map<String, dynamic>);
      rateDay.reference = snapshot.reference;
      return rateDay;
    }).toList();
  }


}