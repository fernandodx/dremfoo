import 'package:flutter/cupertino.dart';

class ValidatorUtil {
  static String validatorEmail(String value) {
    if (value.isEmpty) {
      return "E-mail é obrigatório";
    }
    return null;
  }

  static String validatorPassword(String value) {
    if (value.isEmpty) {
      return "Senha é obrigatório";
    }
    if (value.length < 4) {
      return "Sua senha tem que ter no minímo 8 dígitos";
    }
    return null;
  }

  static String validatorPasswordWithRepit(
      String value, TextEditingController controllerRepit) {

    if (value.isEmpty) {
      return "Senha é obrigatório";
    }
    if (value.length < 4) {
      return "Sua senha tem que ter no minímo 8 dígitos";
    }
    if(controllerRepit != null && controllerRepit.text != value){
      return "A senha não confere";
    }

    return null;
  }

  static String requiredField(String value) {
    if (value.isEmpty) {
      return "Campo obrigatório";
    }
    return null;
  }

  static String fieldsEquals(String value, TextEditingController controller) {
    if (value.isEmpty) {
      return "Campo obrigatório";
    }
    if(value != controller.value.text){
      return "O campo não confere";
    }
    return null;
  }
}
