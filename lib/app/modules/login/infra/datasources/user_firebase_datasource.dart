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
      DocumentSnapshot snapshot = await getRefCurrentUser(uid).get().catchError(handlerError);
      return snapshot.exists;
  }

  @override
  Future<UserRevo> findUserWithUid(String uid) async {
    DocumentSnapshot snapshot = await getRefCurrentUser(uid).get().catchError(handlerError);
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

  Future<int> findCountHitsUser(String uidUser) async {
    DocumentReference refUsers = getRefCurrentUser(uidUser);
    QuerySnapshot querySnapshot = await refUsers.collection("hits").get().catchError(handlerError);
    return querySnapshot.docs.toList().length;
  }





}