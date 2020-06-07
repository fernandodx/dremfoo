import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';

class Utils {

  static bool isCenterTitleAppBar(){
    return Platform.isIOS || Platform.isMacOS;
  }

  static String getPathAssetsImg(nameImg){
    return "assets/images/$nameImg";
  }

  static Image string64ToImage(String imgBase64, {double width = 200, double height = 200, fit = BoxFit.cover}){
    var imgBytes = base64Decode(imgBase64);
    return Image.memory(imgBytes, width: width, height: height, fit: fit,);
  }


}