import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/status_dream_week.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/animation_report_dream_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/card_reward_or_inflection_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/content_count_day_dream_completed_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/content_report_chip_step_widget.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:dremfoo/app/api/extensions/util_extensions.dart';

import 'cicular_progress_revo_widget.dart';

class BodyItemReportDreamWidget extends StatelessWidget {

  final String imgBase64;
  final String nameDream;
  final String descriptionDream;
  final String descriptionNumber;
  final List<StepDream>? listStepDream;
  final Function(String animated)? callbackAnim;
  final Timestamp dateRegisterDream;
  final StatusDreamPeriod period;
  String nameAnimation;
  String pathAnimation;

  BodyItemReportDreamWidget({
    required this.imgBase64,
    required this.nameDream,
    required this.descriptionNumber,
    this.listStepDream,
    required this.callbackAnim,
    required this.dateRegisterDream,
    required this.period,
    required this.nameAnimation,
    required this.pathAnimation,
    required this.descriptionDream,
  });

  @override
  Widget build(BuildContext context) {

    if (period.typeStatusDream == TypeStatusDream.INFLECTION) {
      nameAnimation = "crying";
      pathAnimation = "sad.flr";
    }

    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 16),
      child: Wrap(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                Utils.string64ToImage(imgBase64,
                    fit: BoxFit.cover, width: double.infinity, height: 120),
                Container(
                  decoration: AppColors.backgroundBoxDecorationImg(),
                  child: TextUtil.textAppbar(Translate.i().get.label_dream_progress),
                  width: double.infinity,
                  height: 80,
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.bottomRight,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(right: 160),
                  child: Icon(
                    Icons.refresh,
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 6,
          ),
          TextUtil.textTitulo(nameDream),
          SizedBox(
            height: 6,
          ),
          TextUtil.textDefault(descriptionDream),
          Align(
            alignment: Alignment.topRight,
            child: Chip(
              padding: EdgeInsets.all(8),
              clipBehavior: Clip.antiAlias,
              elevation: 4,
              backgroundColor: Theme.of(context).primaryColorDark,
              label: TextUtil.textChip("${period.number}˚ ${descriptionNumber}", fontSize: 14),
              avatar: CircleAvatar(
                backgroundColor: Theme.of(context).canvasColor,
                child: Icon(
                  Icons.date_range,
                  color: Colors.white70,
                  size: 13,
                ),
              ),
            ),
          ),
          ContentReportChipStepWidget(listStep: listStepDream),
          Container(
            padding: EdgeInsets.all(18),
            width: double.maxFinite,
            child: Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      CicularProgressRevoWidget(
                          isHalf: true,
                          radius: 55,
                          colorText: Theme.of(context).canvasColor,
                          titleCenter:
                          period.difficulty!.formatIntPercent,
                          value: period.difficulty!/100),

                      Container(
                          margin: EdgeInsets.only(top: 35, left: 12),
                          child: TextUtil.textDefault(Translate.i().get.label_goal)
                      ),
                    ],
                  ),

                  SpaceWidget(isSpaceRow: true,),

                  CicularProgressRevoWidget(
                      radius: 55,
                      titleCenter:
                      period.percentCompleted!.toIntPercent,
                      colorText: Theme.of(context).canvasColor,
                      value: period.percentCompleted!),

                  SpaceWidget(isSpaceRow: true,),

                  Expanded(child: AnimationReportDreamWidget(
                    typeStatusDream: period.typeStatusDream!,
                    periodStatus: period.periodStatusDream!,
                    pathAnimation: pathAnimation,
                    nameAnimation: nameAnimation,
                    callbackAnim: callbackAnim,
                  )),

                ],
              ),
            ),
          ),
         CardRewardOrInflectionWidget(typeStatusDream: period.typeStatusDream!, descriptionAction: period.descriptionAction??""),
         ContentCountDayDreamCompletedWidget(dateInit: dateRegisterDream.toDate(),),
        ],
      ),
    );
  }
}
