import 'package:dremfoo/resources/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextDefault extends StatelessWidget {
  String name;
  String hint;
  int maxLength;
  bool isPassword;
  TextEditingController controller;
  FormFieldValidator<String> validator;
  TextInputType inputType;
  TextInputAction inputAction;
  FocusNode focus;
  FocusNode nextFocus;
  Function onSaved;
  IconData icon;
  Function onFieldSubmitted;

  AppTextDefault({
    @required this.name,
    @required this.maxLength,
    this.hint = "",
    this.isPassword = false,
    this.controller,
    this.validator,
    this.inputType,
    this.inputAction,
    this.focus,
    this.nextFocus,
    this.onSaved,
    this.icon,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isPassword,
      keyboardType: inputType,
      focusNode: focus,
      textInputAction: inputAction,
      onSaved: onSaved,
      maxLength: maxLength,
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(color: AppColors.colorDark, fontSize: 15, ),
      onFieldSubmitted: (value) {
        print(value);
        if (onFieldSubmitted != null) {
          onFieldSubmitted(value);
        }
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      decoration: inputDecotaration(),
    );
  }

  InputDecoration inputDecotaration() {
    if (icon != null) {
      return InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), gapPadding: 8, ),
        contentPadding: EdgeInsets.all(10),
        labelText: name,
        hintText: hint,
        labelStyle: TextStyle(fontSize: 16, ),
        prefixIcon: Icon(icon, color: AppColors.colorPrimaryDark, size: 18,),
      );
    } else {
      return InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), gapPadding: 8, ),
        contentPadding: EdgeInsets.all(10),
        labelText: name,
        hintText: hint,
        labelStyle: TextStyle(fontSize: 16, ),
      );
    }
  }
}
