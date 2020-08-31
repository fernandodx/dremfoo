import 'package:dremfoo/model/user.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class CrashlyticsUtil {

  static Crashlytics _crashlytics = Crashlytics.instance;

  static void init(){
    FlutterError.onError = Crashlytics.instance.recordFlutterError;
    _crashlytics.enableInDevMode = false;
  }

  static void enableDevMode(){
    _crashlytics.enableInDevMode = true;
  }

  static void addParam(String key, String value){
    _crashlytics.setString(key, value);
  }

  static void addUserIdentifier(UserRevo user){
    _crashlytics.setUserIdentifier(user.uid);
    _crashlytics.setUserName(user.name);
    _crashlytics.setUserEmail(user.email);
  }

  static void logErro(dynamic exception, StackTrace stack){
    _crashlytics.recordError(exception, stack);
  }



}