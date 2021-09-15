import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:flutter/material.dart';

import 'cicular_progress_revo_widget.dart';

class InfoPercentDreamWidget extends StatelessWidget {

  final String percentStep;
  final String percentToday;
  InfoPercentDreamWidget({required this.percentStep, required this.percentToday});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 16),
        width: double.maxFinite,
        alignment: Alignment.topRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpaceWidget(),
            CicularProgressRevoWidget(
                titleCenter: percentStep, titleBottom: Translate.i().get.label_steps, value: 0.3),
            SpaceWidget(),
            CicularProgressRevoWidget(
                titleCenter: percentToday, titleBottom: Translate.i().get.label_today, value: 0.7),
          ],
        ));
  }
}
