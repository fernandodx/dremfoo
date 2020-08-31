import 'dart:convert';

class PushNotification {

  Map data;
  Map notification;
  String body;
  String title;
  String message;
  String payload;

  PushNotification.fromMap(Map<String, dynamic> map) {
    data = map["data"];
    notification = map["notification"];
    body = notification["body"];
    title = notification["title"];

    if(body.contains("&")){
      message = body.substring(0, body.indexOf("&"));
      payload = body.substring(body.indexOf("&")+1 , body.length);
    }else{
      message = body;
    }


  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["data"] = this.title;
    map['notification'] = this.notification;
    map['body'] = this.body;
    map['title'] = this.title;
    return map;
  }



}