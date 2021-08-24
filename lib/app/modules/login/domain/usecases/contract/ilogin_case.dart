import 'package:dremfoo/app/model/response_api.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

abstract class ILoginCase {

  Future<ResponseApi<User>> loginWithEmailAndPassword(UserRevo userRevo);

  Future<ResponseApi> rememberPassword(String? email);

  Future<ResponseApi<User>> loginWithFacebook();

  Future<ResponseApi<User>> loginWithGoogle();

}