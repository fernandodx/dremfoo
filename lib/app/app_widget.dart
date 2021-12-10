import 'package:dremfoo/app/app_controller.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/AppContext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class AppWidget extends StatefulWidget {
  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> with WidgetsBindingObserver {
  AppController controller = AppController.getInstance();


  @override
  void initState() {
    super.initState();
    changeTheme();
  }

  void changeTheme() {
    var window = WidgetsBinding.instance!.window;
    window.onPlatformBrightnessChanged = () {
      var brightness = window.platformBrightness;
      if(brightness == Brightness.dark) {
        bool isDarktheme = brightness == Brightness.dark;
        controller.changeTheme(isDarktheme, context);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: controller.notifierTheme,
        builder: (BuildContext context, ThemeData theme, Widget? child) {
          return MaterialApp(
            title: 'REVO - Metas com foco',
            debugShowCheckedModeBanner: false,
            theme: theme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ).modular();
        });
  }


}
