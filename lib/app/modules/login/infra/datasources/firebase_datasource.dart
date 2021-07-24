import 'dart:async';

import 'package:dremfoo/app/api/firebase_service.dart';
import 'package:dremfoo/app/modules/login/infra/datasources/contract/ilogin_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';

class FirebaseDataSource implements ILoginDatasource {

  Completer<String> _instance = Completer<String>();
  // Completer<FirebaseAuth> _auth = Completer<FirebaseAuth>();
  FirebaseAuth _auth = FirebaseAuth.instance;

  _init() async {

    Future.delayed(Duration(seconds: 2)).then((value) {
      _instance.complete("Finish");
    });

  }

  FirebaseDataSource(){
   _init();
  }

  Future exempleMethod() async {
    var value = await _instance.future;
  }

  @override
  Future<void> sendResetPassword(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }



}