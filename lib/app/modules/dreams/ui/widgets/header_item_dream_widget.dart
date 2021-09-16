import 'package:flutter/material.dart';

import 'image_positioned_left_widget.dart';
import 'info_percent_dream_widget.dart';

class HeaderItemDreamWidget extends StatelessWidget {
  final String urlImage;
  final Function()? onTapImage;
  final String percentStep;
  final String percentToday;
  final double valueStep;
  final double valueToday;

  HeaderItemDreamWidget(
      {required this.urlImage,
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
              urlImage: urlImage,
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
