import 'package:dremfoo/resources/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextUtil {
  static Text textAppbar(String value) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 17,
        color: Colors.white,
      ),
    );
  }

  static Text textDefault(String value,
      {int maxLines = 10,
      double fontSize = 14,
      TextAlign align = TextAlign.start}) {
    return Text(
      value,
      textAlign: align,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        color: AppColors.colorText
      ),
    );
  }

  static Text textSubTitle(String value,
      {int maxLines = 10,
        double fontSize = 12,
        TextAlign align = TextAlign.start}) {
    return Text(
      value,
      textAlign: align,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: fontSize,
          color: AppColors.colorSubText
      ),
    );
  }

  static Text textChip(String value,
      {int maxLines = 10,
        double fontSize = 14,
        TextAlign align = TextAlign.start}) {
    return Text(
      value,
      textAlign: align,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: fontSize,
          color: AppColors.colorTextChip
      ),
    );
  }

  static Text textChipLight(String value,
      {int maxLines = 10,
        double fontSize = 14,
        TextAlign align = TextAlign.start}) {
    return Text(
      value,
      textAlign: align,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: fontSize,
          color: AppColors.colorlight
      ),
    );
  }

  static Text textLight(String value,
      {int maxLines = 10,
        double fontSize = 14,
        TextAlign align = TextAlign.start}) {
    return Text(
      value,
      textAlign: align,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        color: AppColors.colorlight
      ),
    );
  }


  static Text textTitleMenu(String value,
      {int maxLines = 10,
      double fontSize = 14,
      TextAlign align = TextAlign.start}) {
    return Text(
      value,
      textAlign: align,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: fontSize,
          color: AppColors.colorTextTitleMenu,
          fontWeight: FontWeight.bold),
    );
  }

  static Text textSubTitleMenu(String value,
      {int maxLines = 10,
        double fontSize = 14,
        TextAlign align = TextAlign.start}) {
    return Text(
      value,
      textAlign: align,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: fontSize,
          color: AppColors.colorTextSubTitleMenu,),
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

  static Text textTitulo(String value, {TextAlign align = TextAlign.start}) {
    return Text(
      value,
      textAlign: align,
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.colorText),
    );
  }

  static Text textTituloStep(String value, {TextAlign align = TextAlign.start}) {
    return Text(
      value,
      textAlign: align,
      style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.colorText),
    );
  }

  static Text textTituloVideo(String value,
      {TextAlign align = TextAlign.start, double fontSize = 13,}) {
    return Text(
      value,
      textAlign: align,
      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: AppColors.colorlight),
    );
  }
}
