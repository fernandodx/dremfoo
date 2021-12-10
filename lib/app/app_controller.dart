import 'package:dremfoo/app/modules/login/domain/stories/register_user_store.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobx/mobx.dart';

class AppController  {

  static AppController? _instance = null;

  static AppController getInstance() {
    if(_instance == null) {
      _instance = AppController();
    }
    return _instance!;
  }

  ValueNotifier<ThemeData> notifierTheme = ValueNotifier(ThemeData.dark());
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

  ThemeData get darkTheme => ThemeData.dark().copyWith(
      primaryColor: AppColors.colorPrimaryDark,
      textTheme: GoogleFonts.alataTextTheme(
        Theme.of(_context).textTheme,
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
          labelStyle: ThemeData.dark().textTheme.bodyText1!.copyWith(
              color: AppColors.colorPrimaryDark,
              fontSize: 12,
              fontFamily: GoogleFonts.alata().fontFamily),
          secondaryLabelStyle: TextStyle(color: AppColors.colorTextLight),
          brightness: Brightness.dark));

  ThemeData get lightTheme => ThemeData.light().copyWith(
      textTheme: GoogleFonts.alataTextTheme(
        Theme.of(_context).textTheme,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: AppColors.colorPrimary,
      accentColor: AppColors.colorAcent,
      primaryColorDark: AppColors.colorPrimaryDark,
      canvasColor: Colors.transparent,
      buttonColor: AppColors.colorPrimaryDark,
      cardColor: AppColors.colorCard);

}