import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CicularProgressRevoWidget extends StatelessWidget {
  final String titleCenter;
  final String? titleBottom;
  final double value;
  final double radius;
  final bool isHalf;
  final Color colorText;

  CicularProgressRevoWidget(
      {required this.titleCenter,
      this.titleBottom,
      required this.value,
      this.radius = 50,
        this.isHalf = false,
      this.colorText = Colors.white});

  @override
  Widget build(BuildContext context) {

    if(isHalf){
      return CircularPercentIndicator(
        radius: radius,
        lineWidth: 6,
        percent: value,
        animation: true,
        animationDuration: 1000,
        arcType: ArcType.HALF,
        center: TextUtil.textChipLight(titleCenter, fontSize: 10, color: colorText),
        footer: TextUtil.textChipLight(titleBottom ?? "", fontSize: 14, color: colorText),
        circularStrokeCap: CircularStrokeCap.round,
         backgroundColor: Theme.of(context).backgroundColor.withAlpha(200),
        linearGradient: LinearGradient(
            colors: [Theme.of(context).primaryColorDark, Theme.of(context).hintColor],
           ),
        backgroundWidth: 12,
        startAngle: 180,
      );
    }else{
      return CircularPercentIndicator(
        radius: radius,
        lineWidth: 6,
        percent: value,
        animation: true,
        animationDuration: 1000,
        center: TextUtil.textChipLight(titleCenter, fontSize: 10, color: colorText),
        footer: TextUtil.textChipLight(titleBottom ?? "", fontSize: 14, color: colorText),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).backgroundColor.withAlpha(200),
        backgroundWidth: 12,
        startAngle: 180,
      );
    }
  }
}
