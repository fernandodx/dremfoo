import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/status_dream_week.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class AnimationReportDreamWidget extends StatelessWidget {
  final TypeStatusDream typeStatusDream;
  final PeriodStatusDream periodStatus;
  final String pathAnimation;
  final String nameAnimation;
  final Function(String animated)? callbackAnim;

  AnimationReportDreamWidget(
      {required this.typeStatusDream,
      required this.periodStatus,
      required this.pathAnimation,
      required this.nameAnimation,
      this.callbackAnim});

  @override
  Widget build(BuildContext context) {
    String status = typeStatusDream == TypeStatusDream.REWARD ? Translate.i().get.label_fulfilled : Translate.i().get.label_unfulfilled;
    String descriptionPeriod = periodStatus == PeriodStatusDream.MONTHLY ? Translate.i().get.label_monthly : Translate.i().get.label_weekly;

    return Container(
      width: double.maxFinite,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.all(16),
              height: 70,
              width: 70,
              child: FlareActor(
                Utils.getPathAssetsAnim(pathAnimation),
                shouldClip: true,
                animation: nameAnimation,
                fit: BoxFit.contain,
                callback: callbackAnim,
              )),
          TextUtil.textDefault("${Translate.i().get.label_goal} $descriptionPeriod $status.", align: TextAlign.center)
        ],
      ),
    );
  }
}


