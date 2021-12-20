import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/color_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/widget/app_text_default.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContentStepSettingsDreamWidget extends StatelessWidget {

  final Widget expansionInfo;
  final bool isWait;
  final List<ColorDream> listColorDream;
  final Dream dream;
  final Function(ColorDream) onChangeColorDream;
  final Function(double)? onChangeValueGoalWeek;
  final Function(double)? onChangeValueGoalMonth;


  ContentStepSettingsDreamWidget({
      required this.expansionInfo,
      required this.isWait,
      required this.listColorDream,
      required this.dream,
      required this.onChangeColorDream,
      this.onChangeValueGoalWeek,
      this.onChangeValueGoalMonth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: getListWidgetsConfig(context),
    );
  }

  List<Widget> getListWidgetsConfig(BuildContext context) {
    if (isWait) {
      return listDefinitionColors(context);
    } else {
      List<Widget> list = createListDefinitionGoal();
      list.addAll(listDefinitionColors(context));
      return list;
    }
  }

  List<Widget> createListDefinitionGoal() {
    return [
      expansionInfo,
      SpaceWidget(),
      SpaceWidget(),
      TextUtil.textTitulo(Translate.i().get.label_weekly_goal),
      Container(
        padding: EdgeInsets.only(
          top: 10,
        ),
        child: Slider(
          value: dream.goalWeek??0,
          onChanged: onChangeValueGoalWeek,
          min: 25,
          max: 100,
          divisions: 3,
          label: getLabelSlide(dream.goalWeek??0),
        ),
      ),
      SpaceWidget(),
      TextUtil.textTitulo(Translate.i().get.label_monthly_goal,),
      Container(
        padding: EdgeInsets.only(
          top: 10,
        ),
        child: Slider(
          value: dream.goalMonth??0,
          onChanged:onChangeValueGoalMonth,
          min: 25,
          max: 100,
          divisions: 3,
          label: getLabelSlide(dream.goalMonth??0),
        ),
      ),
      SpaceWidget()
    ];
  }

  String getLabelSlide(double value) {
    switch (value.toInt()) {
      case 0:
        return Translate.i().get.label_disabled;
      case 25:
        return Translate.i().get.label_beginner;
      case 50:
        return Translate.i().get.label_moderate;
      case 75:
        return Translate.i().get.label_out_average;
      case 100:
        return Translate.i().get.label_extraordinary;
    }
    return Translate.i().get.label_disabled;
  }

  List<Widget> listDefinitionColors(BuildContext context) {
    return [
      Row(
        children: <Widget>[
          CircleAvatar(
            radius: 22,
            child: ClipOval(
              child: Image.asset(
                Utils.getPathAssetsImg("icon_paint.png"),
                width: 35,
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 12),
              child: TextUtil.textDefault(Translate.i().get.label_choice_color_dream)),
        ],
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: getListviewColors(listColorDream),
      ),
    ];
  }

  ListView getListviewColors(List<ColorDream> listColors) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listColors.length,
        itemBuilder: (context, index) {
          Color color = Utils.colorFromHex(listColors[index].primary!);
          return InkWell(
            child: Container(
              padding: EdgeInsets.all(8),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: color,
                child: getIconColor(color),
              ),
            ),
            onTap: () {
              onChangeColorDream(listColors[index]);
            },
          );
        });
  }

  Icon getIconColor(Color color) {
    if (dream.color?.primary?.toUpperCase() ==
            Utils.colorToHex(color, leadingHashSign: false).toUpperCase()) {
      return Icon(
        Icons.check,
        color: Colors.white,
      );
    } else {
      return Icon(
        Icons.adjust,
        color: Colors.white,
      );
    }
  }

}