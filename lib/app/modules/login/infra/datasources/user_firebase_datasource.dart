import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/infra/datasources/contract/iuser_datasource.dart';
import 'package:dremfoo/app/resources/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserFirebaseDataSource implements IUserDataSource {

  Completer<String> _instance = Completer<String>();
  // Completer<FirebaseAuth> _auth = Completer<FirebaseAuth>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  _init() async {

    Future.delayed(Duration(seconds: 2)).then((value) {
      _instance.complete(" FirebaseDataSource Finish");
    });

  }

  UserFirebaseDataSource(){
   _init();
  }

  Future exempleMethod() async {
    var value = await _instance.future;
  }


  @override
  Future<void> saveUser(UserRevo user, DateTime initNotification, DateTime finishNotification) async {
   return _getRefCurrentUser(user.uid!).set({
      "name": user.name,
      "email": user.email,
      "urlPicture": user.urlPicture,
      "isEnableNotification": Constants.IS_ENABLE_NOTIFICATION_DEFAULT,
      "initNotification": Timestamp.fromDate(initNotification),
      "finishNotification": Timestamp.fromDate(finishNotification)
    }).catchError(_handlerError);
  }

  @override
  Future<Object> saveLastAcessUser(String fireBaseUserUid, Timestamp dateAcess) async {
    DocumentReference refUsers = _getRefCurrentUser(fireBaseUserUid);
    return refUsers.collection("hits").add({"dateAcess": dateAcess}).catchError(_handlerError);
  }

  @override
  Future<bool> isUserUidExist(String uid) async {
      DocumentSnapshot snapshot = await _getRefCurrentUser(uid).get();
      return snapshot.exists;
  }

  DocumentReference _getRefCurrentUser(String uid) {
    return _firestore
        .collection(Constants.ENVIRONMENT)
        .doc(Constants.ENVIRONMENT_NOW)
        .collection("users").doc(uid);
  }

  _handlerError(error, stack) {
    throw error;
  }


}