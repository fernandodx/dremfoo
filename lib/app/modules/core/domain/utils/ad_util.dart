import 'dart:io';

class AdUtil {


  static String get bannerDashboardId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4534614850187593/6656847079';
      // return 'ca-app-pub-3940256099942544/6300978111'; //TESTE
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_BANNER_AD_UNIT_ID>';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get bannerAfterConclusionGoalId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4534614850187593/8011233292';
      // return 'ca-app-pub-3940256099942544/1033173712'; //teste
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_BANNER_AD_UNIT_ID>';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }


}