import 'package:flutter/material.dart';

import 'image_positioned_left_widget.dart';
import 'info_percent_dream_widget.dart';

class HeaderItemDreamWidget extends StatelessWidget {
  final String? imageBase64;
  final Function()? onTapImage;
  final String percentStep;
  final String percentToday;
  final double? valueStep;
  final double? valueToday;
  final bool isDreamAwait;
  final Function()? onTapCreateFocus;
  final bool isLoading;

  HeaderItemDreamWidget(
      {this.imageBase64,
      this.onTapImage,
      required this.percentStep,
      required this.percentToday,
      required this.valueStep,
      required this.valueToday,
      required this.isDreamAwait,
      this.onTapCreateFocus,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          ImagePositionedLeftWidget(
              imageBase64: imageBase64,
              onTap: onTapImage,
              isDreamAwait: isDreamAwait,
              leftPercent: 0.75,
              height: 170),
          InfoPercentDreamWidget(
            isLoading: isLoading,
            valueStep: valueStep,
            valueToday: valueToday,
            percentStep: percentStep,
            percentToday: percentToday,
            isDreamAwait: isDreamAwait,
            onTapCreateFocus: onTapCreateFocus,
          ),
        ],
      ),
      width: double.maxFinite,
      height: 170,
    );
  }
}
