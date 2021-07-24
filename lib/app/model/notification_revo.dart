import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationRevo {

  String title;
  String msg;
  DocumentReference reference;

  NotificationRevo.fromMap(Map<String, dynamic> map) {
    title = map["title"];
    msg = map["msg"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["title"] = this.title;
    map['msg'] = this.msg;
    return map;
  }

  static List<NotificationRevo> fromListDocumentSnapshot(List<QueryDocumentSnapshot> list){
    return list.map((snapshot) {
      NotificationRevo notification = NotificationRevo.fromMap(snapshot.data());
      notification.reference = snapshot.reference;
      return notification;
    }).toList();
  }


}