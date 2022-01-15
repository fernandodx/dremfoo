import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/infra/datasources/base_datasource.dart';
import 'package:dremfoo/app/modules/login/domain/entities/level_revo.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_focus.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/modules/login/infra/datasources/contract/iuser_datasource.dart';
import 'package:dremfoo/app/resources/constants.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserFirebaseDataSource extends BaseDataSource implements IUserDataSource {

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
  Future<void> updatePhotoUser(String uidUser, String urlPhoto) async {

    var currentUser = await FirebaseAuth.instance.currentUser;
    currentUser?.updatePhotoURL(urlPhoto);

    getRefCurrentUser(uidUser).update({
      "urlPicture": urlPhoto,
    }).catchError((onError) => CrashlyticsUtil.logErro(onError, onError));
  }

  @override
  Future<void> updateUser(UserRevo user, DateTime initNotification, DateTime finishNotification) async {

    var currentUser = await FirebaseAuth.instance.currentUser;

    if(currentUser != null) {
      if(user.urlPicture != null){
        currentUser.updatePhotoURL(user.urlPicture);
      }
      if(user.name != null) {
        currentUser.updateDisplayName(user.name);
      }
      if(user.email != null) {
        currentUser.updateEmail(user.email!);
      }
      if(user.password != null) {
        currentUser.updatePassword(user.password!);
      }
    }

    getRefCurrentUser(user.uid!).update({
      "name": user.name,
      "email": user.email,
      "urlPicture": user.urlPicture,
      "isEnableNotification": Constants.IS_ENABLE_NOTIFICATION_DEFAULT,
      "initNotification": Timestamp.fromDate(initNotification),
      "finishNotification": Timestamp.fromDate(finishNotification)
    }).catchError((onError) => CrashlyticsUtil.logErro(onError, onError));
  }


  @override
  Future<Object> saveLastAcessUser(String fireBaseUserUid, Timestamp dateAcess) async {
    DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);
    refUsers.update({
      "dateLastAcess" : dateAcess
    }).catchError(handlerError);
    return refUsers.collection("hits").add({"dateAcess": dateAcess})
            .catchError(handlerError);
  }

  @override
  Future<bool> isUserUidExist(String uid) async {
      DocumentSnapshot snapshot = await getRefCurrentUser(uid).get().catchError(handlerError);
      return snapshot.exists;
  }

  @override
  Future<UserRevo> findUserWithUid(String uid) async {
    DocumentSnapshot snapshot = await getRefCurrentUser(uid).get().catchError(handlerError);
    if(snapshot.data() == null ){
      throw new RevoExceptions
          .msgToUser(error: Exception("Uid não encontrado na base"), msg: "Login não encontrado!");
    }
    UserRevo user = UserRevo.fromMap(snapshot.data() as Map<String, dynamic>);
    user.uid = snapshot.id;
    return user;
  }

  @override
  Future<DateTime> findLastDayAcessForUser(String uid, bool excludeToday) async {
    DocumentReference refUsers = getRefCurrentUser(uid);
    QuerySnapshot query = await refUsers
        .collection("hits")
        .orderBy("dateAcess", descending: true)
        .limit(2)
        .get()
        .catchError(handlerError);

    List<QueryDocumentSnapshot> list = query.docs;

    if(list.isEmpty){
      return DateTime.now();
    }
    int index = 0;
    if(excludeToday) {
      index = list.length > 1 ? 1 : 0;
    }
    Timestamp dateLastAcess = list[index].get('dateAcess');
    return dateLastAcess.toDate();
  }

  @override
  Future<List<UserRevo>> findRankUser() async {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(Constants.ENVIRONMENT)
          .doc(Constants.ENVIRONMENT_NOW)
          .collection("users")
          .where("focus.countDaysFocus", isGreaterThan: 1)
          .orderBy("focus.countDaysFocus", descending: true)
          .get()
          .catchError(handlerError);
      return UserRevo.fromListDocumentSnapshot(querySnapshot.docs);
  }

  @override
  Future<void> saveCountDaysAcess(String uidUser, int count) async {
    DocumentReference refUsers = getRefCurrentUser(uidUser);
    refUsers.update({
      "countDaysAcess" : count
    }).catchError(handlerError);
  }

  @override
  Future<int> findCountHitsUser(String uidUser) async {
    DocumentReference refUsers = getRefCurrentUser(uidUser);
    QuerySnapshot querySnapshot = await refUsers.collection("hits").get().catchError(handlerError);
    return querySnapshot.docs.toList().length;
  }

  @override
  Future<UserFocus?> findFocusUser(String uidUser) async {
    DocumentReference refUsers = getRefCurrentUser(uidUser);
    DocumentSnapshot snapshot = await refUsers
        .get()
        .catchError(handlerError);

    UserRevo user = UserRevo.fromMap(snapshot.data() as Map<String, dynamic>);
    return user.focus;
  }

  @override
  Future<UserFocus> updateFocusUser(String uidUser, UserFocus focus) async {
    DocumentReference refUsers = getRefCurrentUser(uidUser);
    refUsers.update({"focus" : focus.toMap()})
        .catchError(handlerError);
    return focus;
  }

  @override
  Future<LevelRevo> updateLevelUser(String uidUser, LevelRevo level) async {
    DocumentReference refUsers = getRefCurrentUser(uidUser);
    refUsers.update({"level" : level.toMap()})
        .catchError(handlerError);
    return level;
  }

  @override
  Future<List<LevelRevo>> findLevelsWin(int value) async {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("levels")
          .where("initValue", isLessThanOrEqualTo: value)
          .orderBy("initValue", descending: true)
          .get()
          .catchError(handlerError);
      return  LevelRevo.fromListDocumentSnapshot(querySnapshot.docs);
  }

  @override
  Future<void> updateCountDayAcess(String uidUser, int countDays) async {
    DocumentReference refUsers = getRefCurrentUser(uidUser);
    refUsers.update({"countDaysAcess": countDays})
        .catchError(handlerError);
  }






}