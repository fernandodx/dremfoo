import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';

abstract class IUserDataSource {

  Future<void> saveUser(UserRevo user, DateTime initNotification, DateTime finishNotification);

  Future<Object> saveLastAcessUser(String fireBaseUserUid, Timestamp dateAcess);

  Future<bool> isUserUidExist(String uid);

}