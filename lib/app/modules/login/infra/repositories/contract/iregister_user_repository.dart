import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/model/response_api.dart';
import 'package:dremfoo/app/modules/login/domain/entities/level_revo.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_focus.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class IRegisterUserRepository {

  Future<User> createUserWithEmailAndPassword(BuildContext context, UserRevo user);

  Future<String> uploadFileAcountUser(String? fireBaseUserUid, File? file, String id);

  Future<void> updatePhotoUser(String? uidUser, String urlPhoto);

  Future<void> saveUser(UserRevo user, DateTime initNotification, DateTime finishNotification);

  Future<void> updateUser(UserRevo user, DateTime initNotification, DateTime finishNotification);

  Future<Object> saveLastAcessUser(String fireBaseUserUid, Timestamp dateAcess);

  Future<UserRevo> findCurrentUser();

  Future<DateTime> findLastDayAcessForUser(bool excludeToday);

  Future<List<UserRevo>> findRankUser();

  Future<UserFocus?> findFocusUser(String? uidUser);

  Future<UserFocus> updateFocusUser(String? uidUser, UserFocus focus);

  Future<LevelRevo> updateLevelUser(String? uidUser, LevelRevo level);

  Future<List<LevelRevo>> findLevelsWin(int countDayFocus);

  Future<int> findCountHitsUser(String? uidUser);

  Future<void> updateCountDayAcess(String? userUid, int countDays);

}