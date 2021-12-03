import 'dart:convert' as convert;

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/model/user_focus.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserRevo {

  String? uid;
  String? email;
  String? name;
  String? password;
  String? urlPicture;
  Timestamp? initNotification;
  Timestamp? finishNotification;
  bool? isEnableNotification;
  File? picture;
  UserFocus? focus;
  int? countDaysAcess;
  User? userFirebase;

  UserRevo();

  UserRevo.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    email = map["email"];
    name = map["name"];
    password = map["password"];
    urlPicture = map["urlPicture"];
    initNotification = map["initNotification"];
    finishNotification = map["finishNotification"];
    isEnableNotification = map["isEnableNotification"];
    countDaysAcess =  map["countDaysAcess"];
    focus = UserFocus.fromMap(map['focus']);
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["uid"] = this.uid;
    map['email'] = this.email;
    map["name"] = this.name;
    map["password"] = this.password;
    map["urlPicture"] = this.urlPicture;
    map["initNotification"] = this.initNotification;
    map["finishNotification"] = this.finishNotification;
    map["isEnableNotification"] = this.isEnableNotification;
    map["countDaysAcess"] = this.countDaysAcess;
    map["focus"] = this.focus != null ? this.focus!.toMap() : null;
    return map;
  }

  static List<UserRevo> fromListDocumentSnapshot(List<QueryDocumentSnapshot> list){
    return list.map((snapshot) {
      UserRevo userRevo = UserRevo.fromMap(snapshot.data() as Map<String, dynamic>);
      userRevo.uid = snapshot.id;
      return userRevo;
    }).toList();
  }

  String toJson() {
    return convert.json.encode(toMap());
  }

  updateDataUserFirebase(User? user) async {
    if(user != null){
      userFirebase = user;
      uid = user.uid;
      email = user.email;
      if(user.photoURL != null) {
        urlPicture = user.photoURL;
      }
      if(user.displayName != null) {
        name = user.displayName;
      }
    }else{
      userFirebase = null;
    }
  }




}