import 'dart:io';

import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

abstract class IRegisterUserCase {

  Future<ResponseApi<User>> createUserWithEmailAndPassword(BuildContext context, UserRevo userRevo,
      {File? photo});

  Future<ResponseApi<String>> uploadPhotoAcountUser(String fireBaseUserUid, File file);

}
