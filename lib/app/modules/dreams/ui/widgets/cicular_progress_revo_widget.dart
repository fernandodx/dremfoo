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

  CicularProgressRevoWidget(
      {required this.titleCenter,
      this.titleBottom,
      required this.value,
      this.radius = 50,
        this.isHalf = false});

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
        center: TextUtil.textSubTitle(titleCenter, fontSize: 10),
        footer: TextUtil.textSubTitle(titleBottom ?? "", fontSize: 14),
        circularStrokeCap: CircularStrokeCap.round,
         backgroundColor: Colors.white38,
        linearGradient: LinearGradient(
            colors: [AppColors.colorLazulli, AppColors.colorOrangeDark],
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
        center: TextUtil.textSubTitle(titleCenter, fontSize: 10),
        footer: TextUtil.textSubTitle(titleBottom ?? "", fontSize: 14),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: AppColors.colorAcentProgress,
        backgroundColor: Colors.white38,
        backgroundWidth: 12,
        startAngle: 180,
      );
    }
  }
}
