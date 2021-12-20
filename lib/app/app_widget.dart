import 'package:dremfoo/app/app_controller.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
      if (brightness == Brightness.dark) {
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
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ).modular();
        });
  }

  ThemeData get lightTheme => ThemeData.light().copyWith(
        textTheme: GoogleFonts.alataTextTheme(Theme.of(context).textTheme).apply(
            bodyColor: AppColors.colorDarkLiver,
            decorationColor: AppColors.colorCadetBlue,
            displayColor: Colors.blueGrey,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardColor: AppColors.colorCulture,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.colorBlizzardBlueDark,
          selectionColor: AppColors.colorBlizzardBlue,
          selectionHandleColor: AppColors.colorBlizzardBlueDark,
        ),
        primaryColor: AppColors.colorOldLavender,
        primaryColorDark: AppColors.colorDarkLiver,
        accentColor: AppColors.colorMintCream,
        backgroundColor:AppColors.colorLightBlue ,
        canvasColor: AppColors.colorBlizzardBlueDark,
        hintColor: AppColors.colorEnglishLavender,
        disabledColor: AppColors.colorgrayDisabled,
        focusColor: AppColors.colorCadetBlue,
        colorScheme: ThemeData.light()
            .colorScheme
            .copyWith(secondary: AppColors.colorEnglishLavender, primary: AppColors.colorBlizzardBlueDark),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              gapPadding: 8,
              borderSide: BorderSide(color: AppColors.colorBlizzardBlueDark, width: 1.5)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              gapPadding: 8,
              borderSide: BorderSide(width: 1.5)),
          contentPadding: EdgeInsets.all(10),
          labelStyle:
              TextStyle(fontWeight: FontWeight.bold, color: AppColors.colorBlizzardBlueDark),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: AppColors.colorOldLavender
          )
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.colorLightBlue,
          disabledColor: Colors.grey,
          deleteIconColor: AppColors.colorMintCream,
          selectedColor: AppColors.colorLightBlue,
          secondarySelectedColor: AppColors.colorMintCream,
          padding: EdgeInsets.only(left: 1, right: 1, top: 1, bottom: 1),
          labelStyle: ThemeData.dark().textTheme.bodyText1!.copyWith(
              color:  AppColors.colorBlizzardBlueDark,
              fontSize: 12,
              fontFamily: GoogleFonts.alata().fontFamily),
          secondaryLabelStyle: TextStyle(color: AppColors.colorBlizzardBlue),
          brightness: Brightness.light,
        ),

        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(AppColors.colorOldLavender),
          trackColor: MaterialStateProperty.all(AppColors.colorEnglishLavender),
          overlayColor: MaterialStateProperty.all(Colors.pink),
        ),


        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedItemColor: AppColors.colorMintCream,
          selectedItemColor: AppColors.colorBlizzardBlueDark,
          selectedIconTheme: IconThemeData(
            color: AppColors.colorBlizzardBlueDark
          ),
        ),
      );

}
