import 'package:cloud_firestore/cloud_firestore.dart';

class ColorDream {
  String primary;
  String secondary;
  DocumentReference reference;

  ColorDream.fromMap(Map<String, dynamic> map) {
    primary = map["primary"];
    secondary = map["secondary"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["primary"] = this.primary;
    map['secondary'] = this.secondary;
    return map;
  }

  static List<ColorDream> fromListDocumentSnapshot(
      List<QueryDocumentSnapshot> list) {
    return list.map((snapshot) {
      ColorDream notification = ColorDream.fromMap(snapshot.data());
      notification.reference = snapshot.reference;
      return notification;
    }).toList();
  }
}
