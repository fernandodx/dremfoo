import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:flutter/material.dart';

import 'cicular_progress_revo_widget.dart';

class InfoPercentDreamWidget extends StatelessWidget {

  final String percentStep;
  final String percentToday;
  final double valueStep;
  final double valueToday;
  InfoPercentDreamWidget({required this.percentStep, required this.percentToday, required this.valueStep, required this.valueToday});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 8),
        width: double.maxFinite,
        alignment: Alignment.topRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpaceWidget(),
            CicularProgressRevoWidget(
                titleCenter: percentStep, titleBottom: Translate.i().get.label_steps, value: valueStep),
            SpaceWidget(),
            CicularProgressRevoWidget(
                titleCenter: percentToday, titleBottom: Translate.i().get.label_today, value: valueToday),
          ],
        ));
  }
}
