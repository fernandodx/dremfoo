import 'dart:io';

import 'package:dremfoo/app/modules/login/domain/entities/level_revo.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

abstract class IRegisterUserCase {

  Future<ResponseApi> updateUser(UserRevo user);

  Future<ResponseApi<User>> createUserWithEmailAndPassword(BuildContext context, UserRevo userRevo,
      {File? photo});

  Future<ResponseApi<String>> uploadPhotoAcountUser(String fireBaseUserUid, File file);

  Future<ResponseApi> updatePhotoUser(File picture);

  Future<ResponseApi<bool>> changeThemeDarkPrefsUser(bool isThemeDark);

  Future<ResponseApi<bool>> isThemeDarkPrefsUser();

  Future<ResponseApi> updateContinuosFocus();

  Future<ResponseApi<LevelRevo>> findLevelCurrent(int countDayFocus);

  Future<ResponseApi<bool>> checkLevelFocusUser();

  Future<ResponseApi<void>> updateCountAcess();

}
