import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const colorPrimary = Color.fromARGB(255, 0, 127, 130);
  static const colorPrimaryLight = Color.fromARGB(255, 78, 183, 185);
  static const colorPrimaryDark = Color.fromARGB(255, 19, 98, 107);
  static const colorPrimaryDarkLight = Color.fromARGB(255, 98, 167, 172);
  static const colorAcent = Color.fromARGB(255, 232, 202, 104);
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
            colors: [colorPrimaryDark, colorPrimaryLight],
            begin: FractionalOffset.center,
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
            colors: [colorPrimaryDark, colorPrimaryLight],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter));
  }

  static backgroundPageGradient() {
    return LinearGradient(
        colors: [Colors.white, Colors.grey[300]],
        begin: FractionalOffset.center,
        end: FractionalOffset.bottomCenter);
  }



}
