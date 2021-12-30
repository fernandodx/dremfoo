import 'package:dremfoo/app/modules/login/domain/stories/register_user_store.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobx/mobx.dart';

class AppController  {

  AppController._();

  static AppController? _instance = null;

  static AppController getInstance() {
    if(_instance == null) {
      _instance = AppController._();
    }
    return _instance!;
  }

  late ValueNotifier<ThemeData> notifierTheme = ValueNotifier(ThemeData.dark());
  late BuildContext _context;

  void changeTheme(bool isThemeDark, BuildContext context){
    _context = context;
    if(isThemeDark){
      notifierTheme.value = darkTheme;
    }else {
      notifierTheme.value = lightTheme;
    }
  }

  bool isThemeDark(){
    return notifierTheme.value.brightness == Brightness.dark;
  }

  ThemeData get lightTheme => ThemeData.light().copyWith(
    textTheme: GoogleFonts.alataTextTheme(Theme.of(_context).textTheme).apply(
      bodyColor: AppColors.colorDarkLiver,
      decorationColor: AppColors.colorCadetBlue,
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
      thumbColor: MaterialStateProperty.all(AppColors.colorTuscany),
      trackColor: MaterialStateProperty.all(AppColors.colorOldLavender),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: AppColors.colorMintCream,
      selectedItemColor: AppColors.colorBlizzardBlueDark,
      selectedIconTheme: IconThemeData(
          color: AppColors.colorBlizzardBlueDark
      ),
    ),
  );

  ThemeData get darkTheme => ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.colorRaisinBlack,
    textTheme: GoogleFonts.alataTextTheme(Theme.of(_context).textTheme).apply(
      bodyColor: AppColors.colorMintCream,
      decorationColor: AppColors.colorAlabaster,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    cardColor: AppColors.colorBlackCofee,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.colorBlizzardBlueDark,
      selectionColor: AppColors.colorBlizzardBlue,
      selectionHandleColor: AppColors.colorBlizzardBlueDark,
    ),
    primaryColor: AppColors.colorOldLavender,
    primaryColorDark: AppColors.colorDarkLiver,
    accentColor: AppColors.colorMintCream,
    backgroundColor:AppColors.colorDarkLiver,
    canvasColor: AppColors.colorTuscany,
    hintColor: AppColors.colorTuscany,
    disabledColor: AppColors.colorgrayDisabled,
    focusColor: AppColors.colorCadetBlue,
    colorScheme: ThemeData.dark()
        .colorScheme
        .copyWith(secondary: AppColors.colorTuscany, primary: AppColors.colorEnglishLavender),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          gapPadding: 8,
          borderSide: BorderSide(color: AppColors.colorEnglishLavender, width: 1.5)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          gapPadding: 8,
          borderSide: BorderSide(width: 1.5)),
      contentPadding: EdgeInsets.all(10),
      labelStyle:
      TextStyle(fontWeight: FontWeight.bold, color: AppColors.colorMintCream),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: AppColors.colorTuscany,
        )
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.colorEnglishLavender,
      disabledColor: Colors.grey,
      deleteIconColor: AppColors.colorMintCream,
      selectedColor: AppColors.colorLightBlue,
      secondarySelectedColor: AppColors.colorMintCream,
      padding: EdgeInsets.only(left: 1, right: 1, top: 1, bottom: 1),
      labelStyle: ThemeData.dark().textTheme.bodyText1!.copyWith(
          color:  AppColors.colorMintCream,
          fontSize: 12,
          fontFamily: GoogleFonts.alata().fontFamily),
      secondaryLabelStyle: TextStyle(color: AppColors.colorBlizzardBlue),
      brightness: Brightness.dark,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(AppColors.colorOldLavender),
      trackColor: MaterialStateProperty.all(AppColors.colorEnglishLavender),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: AppColors.colorMintCream,
      selectedItemColor: AppColors.colorTuscany,
      selectedIconTheme: IconThemeData(
          color: AppColors.colorTuscany
      ),
    ),
  );


}