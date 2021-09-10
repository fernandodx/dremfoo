import 'package:dremfoo/app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {

  static Color get colorPrimary => Utils.colorFromHex("#2E2D4D");
  static Color get colorPrimaryDark => Utils.colorFromHex("#171727");
  static Color get colorAcent => Utils.colorFromHex("#00B1B8");
  static Color get colorCard => Utils.colorFromHex("#FCFFFE");
  static Color get colorText => Utils.colorFromHex("#0D7282");
  static Color get colorTextLight => Utils.colorFromHex("#E3F1F2");
  static Color get colorTextChipMenu => Utils.colorFromHex("#2B371B");
  static Color get colorSubText => Utils.colorFromHex("#E3F1F2");
  static Color get colorStartGradient => Utils.colorFromHex("#6E5A7D");
  static Color get colorEndGradient => Utils.colorFromHex("#1397A9");
  static Color get colorDrawer => Utils.colorFromHex("#13ABC4");
  static Color get colorIconDrawer => Utils.colorFromHex("#6E5773");
  static Color get colorlight => Utils.colorFromHex("#E9E2D0");
  static Color get colorLine => Utils.colorFromHex("#EBFFFB");
  static Color get colorTextTitleMenu => Utils.colorFromHex("#2C232F");
  static Color get colorTextSubTitleMenu => Utils.colorFromHex("#D92C232F");
  static Color get colorChipPrimary => Utils.colorFromHex("#C8F4F9");
  static Color get colorChipSecundary => Utils.colorFromHex("#3CACAE");
  static Color get colorTextChip => Utils.colorFromHex("#211522");
  static Color get colorViolet => Utils.colorFromHex("#6E5773");
  static Color get colorButtonChip => Utils.colorFromHex("#EAFFFD");
  static Color get colorButtonChipDark => Utils.colorFromHex("#0D7282");
  static Color get colorSatin => Utils.colorFromHex("#D45D79");
  static Color get colorPink => Utils.colorFromHex("#EA9085");
  static Color get colorEggShell => Utils.colorFromHex("#E9E2D0");
  static Color get colorLazulli => Utils.colorFromHex("#3161A3");
  static Color get colorPacific => Utils.colorFromHex("#13ABC4");
  static Color get colorEletric => Utils.colorFromHex("#7EFAFF");
  static Color get colorWebColor => Utils.colorFromHex("#EBFFFB");
  static Color get colorDisabled => Utils.colorFromHex("#808080");
  static Color get colorBackground => Utils.colorFromHex("#332E3C");
  static Color get colorAcentProgress => Utils.colorFromHex("#CDE7B0");





  // static const colorPrimary = Color.fromARGB(255, 0, 127, 130);
  static const colorPrimaryLight = Color.fromARGB(255, 78, 183, 185);
  // static const colorPrimaryDark = Color.fromARGB(255, 19, 98, 107);
  static const colorPrimaryDarkLight = Color.fromARGB(255, 98, 167, 172);
  // static const colorAcent = Color.fromARGB(255, 232, 202, 104);
  static const colorAcentLight = Color.fromARGB(255, 242, 224, 125);

  static const colorDark = Color.fromARGB(255, 38, 69, 84);
  static const colorDarkLight = Color.fromARGB(255, 122, 151, 159);
  static const colorGreen = Color.fromARGB(255, 116, 165, 117);
  static const colorGreenLight = Color.fromARGB(255, 160, 205, 161);
  static const colorYellow = Color.fromARGB(255, 232, 202, 104);
  static const colorOrange = Color.fromARGB(255, 238, 187, 101);
  static const colorOrangeLight= Color.fromARGB(255, 245, 213, 127);
  static const colorOrangeDark = Color.fromARGB(255, 232, 118, 81);
  static const colorOrangeDarkLight = Color.fromARGB(255, 242, 164, 124);


  static BoxDecoration backgroundBoxDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
            colors: [colorStartGradient, colorEndGradient],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter));
  }

  static BoxDecoration backgroundBoxDecorationImg() {
    return BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black87],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter));
  }


  static BoxDecoration backgroundDrawerDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
            colors: [colorDrawer ,colorDrawer],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter));
  }

  static BoxDecoration backgroundDrawerHeaderDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
            colors: [colorDrawer, colorStartGradient],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter));
  }

  static backgroundPageGradient() {
    return LinearGradient(
        colors: [Colors.white, Colors.grey[300]!],
        begin: FractionalOffset.center,
        end: FractionalOffset.bottomCenter);
  }



}
