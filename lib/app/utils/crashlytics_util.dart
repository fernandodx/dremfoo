import 'package:dremfoo/app/model/user.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsUtil {

  static FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  static void init(){
    _crashlytics.recordFlutterError;
  }

  static void enableDevMode(){
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  static void addParam(String key, String value){
    _crashlytics.setCustomKey(key, value);
  }

  static void addUserIdentifier(UserRevo user){
    _crashlytics.setUserIdentifier(user.uid!);
    _crashlytics.setCustomKey("name", user.name!);
    _crashlytics.setCustomKey("email", user.email!);
  }

  static void logErro(dynamic exception, StackTrace? stack){
    _crashlytics.recordError(exception, stack);
  }

  static void logError(dynamic exception, {StackTrace? stack}){
    _crashlytics.recordError(exception, stack);
  }




}