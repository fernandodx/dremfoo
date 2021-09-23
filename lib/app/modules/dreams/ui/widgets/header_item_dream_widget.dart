import 'package:flutter/material.dart';

import 'image_positioned_left_widget.dart';
import 'info_percent_dream_widget.dart';

class HeaderItemDreamWidget extends StatelessWidget {
  final String? imageBase64;
  final Function()? onTapImage;
  final String percentStep;
  final String percentToday;
  final double valueStep;
  final double valueToday;

  HeaderItemDreamWidget(
      {this.imageBase64,
      this.onTapImage,
      required this.percentStep,
      required this.percentToday,
      required this.valueStep,
      required this.valueToday});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          ImagePositionedLeftWidget(
              imageBase64: imageBase64,
              onTap: onTapImage,
              leftPercent: 0.75,
              height: 170),
          InfoPercentDreamWidget(
            valueStep: valueStep,
            valueToday: valueToday,
            percentStep: percentStep,
            percentToday: percentToday,
          ),
        ],
      ),
      width: double.maxFinite,
      height: 170,
    );
  }
}
