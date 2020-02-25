import 'package:dremfoo/resources/app_colors.dart';
import 'package:flutter/material.dart';

class AppButtonDefault extends StatelessWidget {
  String label;
  Function onPressed;
  bool isShowProgress;
  TypeButton type;
  TextDecoration decoration;

  AppButtonDefault(
      {this.label,
      @required this.onPressed,
      this.isShowProgress = false,
      this.type = TypeButton.RAISE,
      this.decoration = TextDecoration.none});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TypeButton.FLAT:
        return FlatButton(
          child: Container(
            padding: EdgeInsets.all(2),
            child: getTextButton(),
          ),
          textColor: AppColors.colorAcent,
          onPressed: onPressed,
        );
        break;
      case TypeButton.RAISE:
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.all(2),
            child: getTextButton(),
          ),
          color: AppColors.colorAcent,
          textColor: Colors.white,
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)
          ),
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
      label,
      style: TextStyle(fontSize: 18, decoration: decoration),
    );
  }
}

enum TypeButton { RAISE, FLAT }
