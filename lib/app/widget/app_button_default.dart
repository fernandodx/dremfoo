import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:flutter/material.dart';

class AppButtonDefault extends StatelessWidget {
  String? label;
  VoidCallback? onPressed;
  bool isShowProgress;
  TypeButton type;
  TextDecoration decoration;
  Icon? icon;
  MainAxisSize mainAxisSize;

  AppButtonDefault(
      {this.label,
      required this.onPressed,
      this.isShowProgress = false,
      this.type = TypeButton.RAISE,
      this.icon,
      this.mainAxisSize = MainAxisSize.min,
      this.decoration = TextDecoration.none});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TypeButton.FLAT:
        return TextButton(
          child: Row(
            mainAxisSize: mainAxisSize,
            children: <Widget>[
              Visibility(
                visible: icon != null,
                child: Container(
                  child: icon,
                  margin: EdgeInsets.only(right: 8),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: getTextButton(),
              ),
            ],
          ),
          style: TextButton.styleFrom(
            primary: AppColors.colorAcent
          ),
          onPressed: onPressed,
        );

      case TypeButton.RAISE:
        return ElevatedButton(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: icon != null,
                child: Container(
                  child: icon,
                  margin: EdgeInsets.only(right: 8),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: getTextButton(),
              ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            primary: AppColors.colorPrimaryDark,
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
          onPressed: onPressed,
        );
    }
  }

  Widget getTextButton() {
    if (isShowProgress) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        ),
      );
    }

    return Text(
      label!,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14, decoration: decoration,),
    );
  }
}

enum TypeButton { RAISE, FLAT }
