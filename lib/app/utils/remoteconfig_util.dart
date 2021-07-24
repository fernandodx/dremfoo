import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:dremfoo/app/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigUtil {
  static const String enableMenuVideoRevo = "enableMenuVideoRevo";
  static const enableMenuSocialMedia = "enableMenuSocialMedia";
  static const enableMenuShare = "enableMenuShare";
  static const enableMenuNotificacao = "enableMenuNotificacao";
  static const enableMenuArchive = "enableMenuArchive";
  static const enableMenuDreamCompleted = "enableMenuDreamCompleted";
  static const enableMediaInstagram = "enableMediaInstagram";
  static const enableMediaYoutube = "enableMediaYoutube";
  static const enableMediaSite = "enableMediaSite";
  static const enableMediaContato = "enableMediaContato";

  static RemoteConfig _instance;

  static void init() async {
    _instance = await RemoteConfig.instance;

    await _instance.setConfigSettings(RemoteConfigSettings(debugMode: false));
    // await _instance.setDefaults({
    //   enableMenuVideoRevo: true,
    //   enableMenuSocialMedia: true,
    //   enableMenuShare: true,
    //   enableMenuNotificacao: true,
    //   enableMenuArchive: true,
    //   enableMediaInstagram: true,
    //   enableMediaYoutube: true,
    //   enableMediaSite: true,
    //   enableMediaContato: true,
    //   enableMenuDreamCompleted: true,
    // });

    await _instance.fetch(expiration: const Duration(seconds: 1));
    await _instance.activateFetched();
  }

  bool isEnableMenuVideoRevo() {
    try {
      bool isEnable = _instance.getBool(enableMenuVideoRevo);
      print("*** isEnableMenuVideoRevo *** => $isEnable");
      return isEnable;
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return false;
    }
  }

  bool isEnableMenuSocialMedia() => _instance.getBool(enableMenuSocialMedia);
  bool isEnableMenuShare() => _instance.getBool(enableMenuShare);
  bool isEnableMenuNotificacao() => _instance.getBool(enableMenuNotificacao);
  bool isEnableMenuArchive() => _instance.getBool(enableMenuArchive);
  bool isEnableMenuDreamCompleted() => _instance.getBool(enableMenuDreamCompleted);
  bool isEnableMediaInstagram() => _instance.getBool(enableMediaInstagram);
  bool isEnableMediaYoutube() => _instance.getBool(enableMediaYoutube);
  bool isEnableMediaSite() => _instance.getBool(enableMediaSite);
  bool isEnableMediaContato() => _instance.getBool(enableMediaContato);

}
