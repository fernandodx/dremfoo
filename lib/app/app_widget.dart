import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/AppContext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class AppWidget extends StatefulWidget {
  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> with WidgetsBindingObserver {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();

    theme = darkTheme;

    changeTheme();
  }

  void changeTheme() {
    var window = WidgetsBinding.instance!.window;
    window.onPlatformBrightnessChanged = () {
      var brightness = window.platformBrightness;
      setState(() {
        brightness == Brightness.dark ? theme = darkTheme : theme = lightTheme;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REVO - Metas com foco',
      debugShowCheckedModeBanner: false,
      theme: theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ).modular();
  }

  ThemeData get darkTheme => ThemeData.dark().copyWith(
      primaryColor: AppColors.colorPrimaryDark,
      textTheme: GoogleFonts.alataTextTheme(
        Theme.of(context).textTheme,
      ),
      accentColor: AppColors.colorAcentLight,
      primaryColorDark: AppColors.colorPrimaryDarkLight,
      canvasColor: Colors.transparent,
      buttonColor: AppColors.colorPrimaryDarkLight,
      cardColor: AppColors.colorPrimaryDark,
      chipTheme: ChipThemeData(
          backgroundColor: AppColors.colorButtonChip,
          disabledColor: Colors.grey,
          selectedColor: Colors.greenAccent,
          secondarySelectedColor: Colors.purple,
          padding: EdgeInsets.only(left: 1, right: 1, top: 1, bottom: 1),
          labelStyle:ThemeData.dark().textTheme.bodyText1!
              .copyWith(
              color: AppColors.colorPrimaryDark,
              fontSize: 12,
              fontFamily: GoogleFonts.alata().fontFamily),
          secondaryLabelStyle: TextStyle(color: AppColors.colorTextLight),
          brightness: Brightness.dark));

  ThemeData get lightTheme => ThemeData.light().copyWith(
      textTheme: GoogleFonts.alataTextTheme(
        Theme.of(context).textTheme,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: AppColors.colorPrimary,
      accentColor: AppColors.colorAcent,
      primaryColorDark: AppColors.colorPrimaryDark,
      canvasColor: Colors.transparent,
      buttonColor: AppColors.colorPrimaryDark,
      cardColor: AppColors.colorCard);
}
