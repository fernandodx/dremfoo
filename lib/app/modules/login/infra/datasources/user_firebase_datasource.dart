import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/infra/datasources/base_datasource.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/infra/datasources/contract/iuser_datasource.dart';
import 'package:dremfoo/app/resources/constants.dart';

class UserFirebaseDataSource extends BaseDataSource implements IUserDataSource {

  Completer<String> _instance = Completer<String>();
  // Completer<FirebaseAuth> _auth = Completer<FirebaseAuth>();

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
   return getRefCurrentUser(user.uid!).set({
      "name": user.name,
      "email": user.email,
      "urlPicture": user.urlPicture,
      "isEnableNotification": Constants.IS_ENABLE_NOTIFICATION_DEFAULT,
      "initNotification": Timestamp.fromDate(initNotification),
      "finishNotification": Timestamp.fromDate(finishNotification)
    }).catchError(handlerError);
  }

  @override
  Future<Object> saveLastAcessUser(String fireBaseUserUid, Timestamp dateAcess) async {
    DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);
    return refUsers.collection("hits").add({"dateAcess": dateAcess})
            .catchError(handlerError);
  }

  @override
  Future<bool> isUserUidExist(String uid) async {
      DocumentSnapshot snapshot = await getRefCurrentUser(uid).get();
      return snapshot.exists;
  }


}