import 'package:dremfoo/resources/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextUtil {
  static Text textAppbar(String value) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    );
  }

  static Text textDefault(String value, {int maxLines = 10, Color color = Colors.blueGrey, double fontSize = 14, TextAlign align = TextAlign.start}) {
    return Text(
      value,
      textAlign: align,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }

  static Text textAccent(String value) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 14,
        color: AppColors.colorAcent,
      ),
    );
  }

  static Text textTitulo(String value, {color = AppColors.colorPrimaryDark,  TextAlign align = TextAlign.start}) {
    return Text(
      value,
      textAlign: align,
      style: TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold),
    );
  }

  static Text textTituloVideo(String value, {color = AppColors.colorPrimaryDark,  TextAlign align = TextAlign.start}) {
    return Text(
      value,
      textAlign: align,
      style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.normal),
    );
  }
}
