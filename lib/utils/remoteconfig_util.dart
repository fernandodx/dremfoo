import 'package:dremfoo/utils/crashlytics_util.dart';
import 'package:dremfoo/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigUtil {

  static const String enableMenuVideoRevo = "enableMenuVideoRevo";
  static const enableMenuSocialMedia = "enableMenuSocialMedia";
  static const enableMenuShare = "enableMenuShare";
  static const enableMenuNotificacao = "enableMenuNotificacao";
  static const enableMenuArchive = "enableMenuArchive";
  static const enableMediaInstagram = "enableMediaInstagram";
  static const enableMediaYoutube = "enableMediaYoutube";
  static const enableMediaSite = "enableMediaSite";
  static const enableMediaContato = "enableMediaContato";

  static RemoteConfig _instance;

  static void init() async{
    _instance = await RemoteConfig.instance;
    
    _instance.setConfigSettings(RemoteConfigSettings(debugMode: false));
    _instance.setDefaults({
      enableMenuVideoRevo:false,
      enableMenuSocialMedia:false,
      enableMenuShare:false,
      enableMenuNotificacao:false,
      enableMenuArchive:false,
      enableMediaInstagram:false,
      enableMediaYoutube:false,
      enableMediaSite:false,
      enableMediaContato:false,
    });

    _instance.fetch(expiration: const Duration(seconds: 0));
    _instance.activateFetched();

  }

  bool isEnableMenuVideoRevo() {
    try{
      bool isEnable =  _instance.getBool(enableMenuVideoRevo);
      print("*** isEnableMenuVideoRevo *** => $isEnable");
      return isEnable;
    }catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
      return false;
    }

  }
  bool isEnableMenuSocialMedia() => _instance.getBool(enableMenuSocialMedia);
  bool isEnableMenuShare() => _instance.getBool(enableMenuShare);
  bool isEnableMenuNotificacao() => _instance.getBool(enableMenuNotificacao);
  bool isEnableMenuArchive() => _instance.getBool(enableMenuArchive);
  bool isEnableMediaInstagram() => _instance.getBool(enableMediaInstagram);
  bool isEnableMediaYoutube() => _instance.getBool(enableMediaYoutube);








}