import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const colorPrimary = Color.fromARGB(255, 0, 130, 125);
  static const colorPrimaryDark = Color.fromARGB(255, 0, 80, 77);
  static const colorAcent = Color.fromARGB(255, 214, 141, 0);
  static const colorPrimaryLight = Color.fromARGB(255, 50, 162, 158);

  static BoxDecoration backgroundBoxDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
            colors: [colorPrimaryDark, colorPrimaryLight],
            begin: FractionalOffset.center,
            end: FractionalOffset.bottomCenter));
  }

  static backgroundPageGradient() {
    return LinearGradient(
        colors: [Colors.white, Colors.grey[300]],
        begin: FractionalOffset.center,
        end: FractionalOffset.bottomCenter);
  }
}
