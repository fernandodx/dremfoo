import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/AppContext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REVO - Metas com foco',
      theme: ThemeData(
          fontFamily: "Alata",
          primaryColor: AppColors.colorPrimary,
          accentColor: AppColors.colorAcent,
          primaryColorDark: AppColors.colorPrimaryDark,
          canvasColor: Colors.transparent,
          buttonColor: AppColors.colorPrimaryDark,
          cardColor: AppColors.colorCard
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ).modular();
  }
}