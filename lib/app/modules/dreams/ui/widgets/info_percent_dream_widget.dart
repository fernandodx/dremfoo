import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:flutter/material.dart';

import 'cicular_progress_revo_widget.dart';

class InfoPercentDreamWidget extends StatelessWidget {

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
                titleCenter: "30%", titleBottom: "Etapas", value: 0.3),
            SpaceWidget(),
            CicularProgressRevoWidget(
                titleCenter: "70%", titleBottom: "Hoje", value: 0.7),
          ],
        ));
  }
}
