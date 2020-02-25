import 'dart:convert' as convert;

import 'dart:io';


class User {

  String email;
  String name;
  String password;
  String urlPicture;
  File picture;

  User();

  User.fromMap(Map<String, dynamic> map) {
    email = map["email"];
    name = map["name"];
    password = map["password"];
    urlPicture = map["urlPicture"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['email'] = this.email;
    map["name"] = this.name;
    map["password"] = this.password;
    map["urlPicture"] = this.urlPicture;
    return map;
  }

  String toJson() {
    return convert.json.encode(toMap());
  }

}