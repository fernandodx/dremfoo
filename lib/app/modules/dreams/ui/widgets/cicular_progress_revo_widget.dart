import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CicularProgressRevoWidget extends StatelessWidget {
  final String titleCenter;
  final String titleBottom;
  final double value;

  CicularProgressRevoWidget({required this.titleCenter, required this.titleBottom, required this.value});

  @override
  Widget build(BuildContext context) {
    return  CircularPercentIndicator(
      radius: 50,
      lineWidth: 6,
      percent: value,
      animation: true,
      center: TextUtil.textSubTitle(titleCenter, fontSize: 10),
      footer: TextUtil.textSubTitle(titleBottom, fontSize: 14),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: AppColors.colorAcentProgress,
      backgroundColor: Colors.white38,
      backgroundWidth: 12,
      startAngle: 180,
    );
  }
}