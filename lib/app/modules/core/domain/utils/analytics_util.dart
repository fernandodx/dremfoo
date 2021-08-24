import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsUtil {

  static final FirebaseAnalytics _analytics = FirebaseAnalytics();

  static void sendAnalyticsEvent(String nameEvent, {Map<String, dynamic>? parameters}) {
    _analytics.logEvent(
      name: nameEvent,
      parameters: parameters,
    );
  }

  static void setUserId(String id, ) {
    _analytics.setUserId(id);
  }

  static void setCurrentScreen(String screenName, String nameClass) async {
    await _analytics.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: nameClass,
    );
  }

  static void setUserProperty(String name, String? value){
    _analytics.setUserProperty(name: name, value: value);
  }

  static void sendAppOpen(){
    _analytics.logAppOpen();
  }

  static void sendLogLogin(String method){
    _analytics.logLogin(loginMethod: method);
  }

  static void sendLogShare(String contentType, String itemId, String method){
    _analytics.logShare(
        contentType: contentType,
        itemId: itemId,
        method: method);
  }

  static void sendLogSignUp(String method){
    _analytics.logSignUp(
      signUpMethod: method,
    );
  }

}

