import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/utils.dart';
import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: AppColors.backgroundBoxDecoration(),
        ),
        Container(
          alignment: Alignment.topCenter,
          width: double.infinity,
          child: Image.asset(
            Utils.getPathAssetsImg(
              "logo_background.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
