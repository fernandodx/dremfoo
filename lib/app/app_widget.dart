import 'package:dremfoo/app/app_controller.dart';
import 'package:dremfoo/app/modules/core/config/app_purchase.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

import 'utils/remoteconfig_util.dart';

class AppWidget extends StatefulWidget {
  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> with WidgetsBindingObserver {
  late AppController controller;
  late AppPurchase appPurchase;

  @override
  void initState() {
    super.initState();

    try {
      controller = AppController.getInstance();
      changeTheme();
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
    }

  }

  void changeTheme() {
    var window = WidgetsBinding.instance.window;
    var brightness = window.platformBrightness;
    bool isDarktheme = brightness == Brightness.dark;
    controller.changeTheme(isDarktheme, context);

    // window.onPlatformBrightnessChanged = () {
    //   var brightness = window.platformBrightness;
    //   if (brightness == Brightness.dark) {
    //     bool isDarktheme = brightness == Brightness.dark;
    //     controller.changeTheme(isDarktheme, context);
    //   }
    // };
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: controller.notifierTheme,
        builder: (BuildContext context, ThemeData theme, Widget? child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: controller.notifierTheme.value,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routeInformationParser: Modular.routeInformationParser,
            routerDelegate: Modular.routerDelegate,
          );
        });
  }

}
