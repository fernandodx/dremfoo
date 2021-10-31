import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/widget/app_text_default.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContentStepRewardDreamWidget extends StatelessWidget {

  final Widget expansionInfo;
  final bool isRewardWeek;
  final TextEditingController rewardTextEditController;
  final TextEditingController rewardWeekTextEditController;
  final Function(bool)? onChangeSwitchRewardWeek;

  ContentStepRewardDreamWidget({
      required this.expansionInfo,
      required this.isRewardWeek,
      required this.rewardTextEditController,
      required this.rewardWeekTextEditController,
      this.onChangeSwitchRewardWeek});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        children: <Widget>[
          expansionInfo,
          SpaceWidget(),
          AppTextDefault(
            name: Translate.i().get.label_reward,
            icon: FontAwesomeIcons.trophy,
            maxLength: 80,
            controller: rewardTextEditController,
          ),
          SwitchListTile(
            dense: true,
            value: isRewardWeek,
            title: TextUtil.textDefault(Translate.i().get.label_choice_diff_reward),
            onChanged: onChangeSwitchRewardWeek,
          ),
          getRewardWeek(),
          SpaceWidget()
        ],
      ),
    );
  }

  Widget getRewardWeek() {
    if (isRewardWeek) {
      return Container(
        margin: EdgeInsets.only(top: 12),
        child: AppTextDefault(
          name: Translate.i().get.label_weekly,
          maxLength: 40,
          icon: FontAwesomeIcons.trophy,
          controller: rewardWeekTextEditController,
        ),
      );
    }
    return SizedBox(
      height: 10,
    );
  }


}