import 'package:cloud_firestore/cloud_firestore.dart';

class Video {

  String? id;
  String? name;
  Timestamp? date;
  String? time;
  late DocumentReference reference;

  Video();

  Video.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    name = map["name"];
    date = map["date"];
    time = map["time"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = this.id;
    map['name'] = this.name;
    map["date"] = this.date;
    map["time"] = this.time;
    return map;
  }

  static List<Video> fromListDocumentSnapshot(List<QueryDocumentSnapshot> list){
    return list.map((snapshot) {
      Video video = Video.fromMap(snapshot.data() as Map<String, dynamic>);
      video.reference = snapshot.reference;
      return video;
    }).toList();
  }


}