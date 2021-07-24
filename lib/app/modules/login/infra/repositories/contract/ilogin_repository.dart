import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

abstract class ILoginRepository {

  Future<User> login();

  Future<void> sendResetPassword(String email);

}