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

class UserProperties {
  static String uid = "uid";
  static String email = "email";
  static String urlPicture = "urlPicture";
  static String initNotification = "initNotification";
  static String finishNotification = "finishNotification";
  static String isEnableNotification = "isEnableNotification";
  static String countDream = "Count-Dream";
}

class MethodLogin {
  static String email = "E-mail";
  static String google = "Google";
  static String facebook = "Facebook";
  static String sharedPrefs = "SharedPrefs";
}

class EventRevo {
  static String registerNewUser = "register_new-user";
  static String openApp = "open_app";
  static String registerLogin = "register_login";
  static String forgotPassword = "forgot_login";
  static String newDream = "new_dream";
  static String updateDreamFocus = "update_dream_focus";
  static String addImageDream = "add_image_dream";
  static String addImageDreamInternet = "add_image_dream_internet";
  static String dreamFinish = "dream_finish";
  static String dreamDeleted = "dream_deleted";
  static String addDailyForDream = "add_daily_for_dream";
  static String addStepforDream = "add_step_for_dream";
  static String menuPainel = "menu_painel";
  static String menuDreamDeleted = "menu_dream_deleted";
  static String menuDreamCompleted = "menu_dream_completed";
  static String menuNotification = "menu_notification";
  static String menuYoutube = "menu_youtube";
  static String menuMediaSocial = "menu_media_social";
  static String menuShare = "menu_share";
  static String menuExit = "menu_exit";
}
