import 'dart:convert' as convert;

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';


class User {

  String uid;
  String email;
  String name;
  String password;
  String urlPicture;
  File picture;
  Timestamp lastAcess;

  User();

  User.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    email = map["email"];
    name = map["name"];
    password = map["password"];
    urlPicture = map["urlPicture"];
    lastAcess = map["lastAcess"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["uid"] = this.uid;
    map['email'] = this.email;
    map["name"] = this.name;
    map["password"] = this.password;
    map["urlPicture"] = this.urlPicture;
    map["lastAcess"] = this.lastAcess;
    return map;
  }

  String toJson() {
    return convert.json.encode(toMap());
  }



}