import 'package:dremfoo/app/modules/core/domain/utils/analytics_util.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RevoAnalytics {

  void setUserPropertiesDefault(UserRevo user) {
    AnalyticsUtil.setUserProperty("uid", user.uid);
    AnalyticsUtil.setUserProperty("name", user.name);
    AnalyticsUtil.setUserProperty("email", user.email);
    AnalyticsUtil.setUserProperty("urlPicture", user.urlPicture);
  }

  void eventRegisterNewUser({required String email, required String name}) {
    AnalyticsUtil.sendAnalyticsEvent(EventRevo.registerNewUser, parameters: {
      "email": email,
      "name": name
    });
  }

  void eventForgotPassword(String email) {
    AnalyticsUtil.sendAnalyticsEvent(EventRevo.forgotPassword, parameters: {"user": email});
  }

  void eventLoginWithEmail(String method){
    AnalyticsUtil.sendLogLogin(method);
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
  static String likeRevo = "like_revo";
  static String noLikeRevo = "no_like_revo";
}