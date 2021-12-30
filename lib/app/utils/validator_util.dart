import 'package:dremfoo/app/utils/Translate.dart';
import 'package:flutter/cupertino.dart';

class ValidatorUtil {
  static String? validatorEmail(String? value) {
    if (value == null || value.isEmpty) {
      return Translate.i().get.label_required_email;
    }

    if(!value.contains("@")){
      return Translate.i().get.label_passaword_invalid;
    }
    return null;
  }

  static String? validatorPassword(String? value) {
    if (value == null || value.isEmpty) {
      return Translate.i().get.label_required_password;
    }
    if (value.length < 4) {
      return Translate.i().get.label_min_character_password;
    }
    return null;
  }

  static String? validatorPasswordWithRepit(
      String value, TextEditingController controllerRepit) {

    if (value.isEmpty) {
      return Translate.i().get.label_required_password;
    }
    if (value.length < 4) {
      return Translate.i().get.label_min_character_password;
    }
    if(controllerRepit != null && controllerRepit.text != value){
      return Translate.i().get.label_password_no_match;
    }

    return null;
  }

  static String?  requiredField(String? value) {
    if (value == null || value.isEmpty) {
      return Translate.i().get.label_required_field;
    }
    return null;
  }


}
