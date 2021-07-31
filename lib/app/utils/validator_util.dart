import 'package:flutter/cupertino.dart';

class ValidatorUtil {
  static String? validatorEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "E-mail é obrigatório";
    }

    if(!value.contains("@")){
      return "E-mail é inválido";
    }
    return null;
  }

  static String? validatorPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Senha é obrigatória";
    }
    if (value.length < 4) {
      return "Sua senha tem que ter no minímo 8 dígitos";
    }
    return null;
  }

  static String? validatorPasswordWithRepit(
      String value, TextEditingController controllerRepit) {

    if (value.isEmpty) {
      return "Senha é obrigatória";
    }
    if (value.length < 4) {
      return "Sua senha tem que ter no minímo 8 dígitos";
    }
    if(controllerRepit != null && controllerRepit.text != value){
      return "A senha não confere";
    }

    return null;
  }

  static String?  requiredField(String? value) {
    if (value == null || value.isEmpty) {
      return "Campo obrigatório";
    }
    return null;
  }


}
