import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/widget/app_text_default.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContentStepInflectionDreamWidget extends StatelessWidget {

  final Widget expansionInfo;
  final bool isInflectionWeek;
  final TextEditingController inflectionTextEditController;
  final TextEditingController inflectionWeekTextEditController;
  final Function(bool)? onChangeSwitchInflectionWeek;

  ContentStepInflectionDreamWidget({
      required this.expansionInfo,
      required this.isInflectionWeek,
      required this.inflectionTextEditController,
      required this.inflectionWeekTextEditController,
      this.onChangeSwitchInflectionWeek});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(top: 16),
      child:  Container(
        margin: EdgeInsets.only(top: 16),
        child: Column(
          children: <Widget>[
            expansionInfo,
            SpaceWidget(),
            AppTextDefault(
              name: Translate.i().get.label_inflection_point,
              icon: Icons.build,
              maxLength: 80,
              controller: inflectionTextEditController,
            ),
            SwitchListTile(
              value: isInflectionWeek,
              title: TextUtil.textDefault(Translate.i().get.label_choice_diff_inflection),
              onChanged: onChangeSwitchInflectionWeek,
            ),
            getInflectionWeek(),
            SpaceWidget(),
          ],
        ),
      ),
    );
  }

  Widget getInflectionWeek() {
    if (isInflectionWeek) {
      return Container(
        margin: EdgeInsets.only(top: 12),
        child: AppTextDefault(
          name: Translate.i().get.label_inflection_point_weekly,
          maxLength: 40,
          icon: Icons.build,
          controller: inflectionWeekTextEditController,
        ),
      );
    }
    return SizedBox(
      height: 10,
    );
  }


}