import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:flutter/material.dart';

class AppButtonDefault extends StatelessWidget {
  String? label;
  Function onPressed;
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
        return FlatButton(
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
                padding: EdgeInsets.all(2),
                child: getTextButton(),
              ),
            ],
          ),
          textColor: AppColors.colorAcent,
          onPressed: onPressed as void Function()?,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
        break;
      case TypeButton.RAISE:
        return RaisedButton(
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
                padding: EdgeInsets.all(2),
                child: getTextButton(),
              ),
            ],
          ),
          textColor: Colors.white,
          onPressed: onPressed as void Function()?,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
