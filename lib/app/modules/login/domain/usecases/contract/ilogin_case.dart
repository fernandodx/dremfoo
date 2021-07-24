import 'package:dremfoo/app/model/response_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

abstract class ILoginCase {

  Future<User> login(BuildContext context);

  Future<ResponseApi> rememberPassword(String email);

  Future<void> sendResetPassword(String email);

}