import 'dart:io';
import 'dart:convert';

import 'package:date_util/date_util.dart';
import 'package:dremfoo/resources/PortuguesLocale.dart';
import 'package:dremfoo/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static bool isCenterTitleAppBar() {
    return Platform.isIOS || Platform.isMacOS;
  }

  static String getPathAssetsImg(nameImg) {
    return "assets/images/$nameImg";
  }

  static String getPathAssetsAnim(nameAnim) {
    return "assets/animations/$nameAnim";
  }

  static String addZeroLeft(int number) {
    return number <= 9 ? "0$number" : "$number";
  }

  static Image string64ToImage(String imgBase64, {double width = 200, double height = 200, fit = BoxFit.cover}) {
    var imgBytes = base64Decode(imgBase64);
    return Image.memory(
      imgBytes,
      width: width,
      height: height,
      fit: fit,
    );
  }

  static int getDayWeekInitSunday(int dayWeek) {
    if (dayWeek + 1 >= 8) {
      return 1;
    }

    return dayWeek + 1;
  }

  static int getNumberWeek(DateTime date) {
    int countDay = DateUtil().daysPastInYear(date.month, date.day, date.year);
    int dayWeek = getDayWeekInitSunday(date.weekday);
    return ((countDay - dayWeek + 10) / 7).floor();
  }

  static String dateToString(DateTime date) {
    return formatDate(date, [dd, '/', mm, '/', yyyy], locale: PortuguesLocale());
  }

  static String dateToStringExtension(DateTime date, ) {
    return formatDate(date, [dd, ' de ', MM, ' de ', yyyy], locale: PortuguesLocale());
  }

  static DateTime stringToDate(String dateString) {
    //format 2012-02-27
    return DateTime.parse(dateString);
  }

  static List<Color> getColorsDream() {
    return [
      AppColors.colorGreen,
      AppColors.colorGreenLight,
      AppColors.colorDark,
      AppColors.colorDarkLight,
      AppColors.colorYellow,
      AppColors.colorOrange,
      AppColors.colorOrangeLight,
      AppColors.colorOrangeDark,
      AppColors.colorOrangeDarkLight,
    ];
  }

  static Color colorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  static String colorToHex(Color color, {bool leadingHashSign = true}) {
    return '${leadingHashSign ? '#' : ''}'
        '${color.alpha.toRadixString(16).padLeft(2, '0')}'
        '${color.red.toRadixString(16).padLeft(2, '0')}'
        '${color.green.toRadixString(16).padLeft(2, '0')}'
        '${color.blue.toRadixString(16).padLeft(2, '0')}';
  }

  static month(monthNum) {
    List<String> month = [
      "Janeiro",
      "Fevereiro",
      "Março",
      "Abril",
      "Maio",
      "Junho",
      "Julho",
      "Agosto",
      "Setembro",
      "Outubro",
      "Novembro",
      "Dezembro"
    ];

    return month[monthNum - 1];
  }

  static weekday(int length, bool isSundayFirstDay) {
    List<String> days = ["SEG", "TER", "QUA", "QUI", "SEX", "SAB", "DOM"];
    return days[length - 1];
  }

  static openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static DateTime resetStartDay(DateTime currentDate) {
   return DateTime(currentDate.year, currentDate.month, currentDate.day);
  }

  static DateTime resetEndDay(DateTime currentDate) {
    return DateTime(currentDate.year, currentDate.month, currentDate.day, 23, 59, 59);
  }
}
