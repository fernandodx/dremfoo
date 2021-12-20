import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'cicular_progress_revo_widget.dart';

class InfoPercentDreamWidget extends StatelessWidget {
  final String percentStep;
  final String percentToday;
  final double? valueStep;
  final double? valueToday;
  final bool isDreamAwait;
  final bool isLoading;
  final Function()? onTapCreateFocus;

  InfoPercentDreamWidget(
      {required this.percentStep,
      required this.percentToday,
      required this.valueStep,
      required this.valueToday,
      required this.isDreamAwait,
      this.onTapCreateFocus,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 8),
        width: double.maxFinite,
        alignment: Alignment.topRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _createWidgets(context),
        ));
  }

  List<Widget> _createWidgets(BuildContext context) {
    if (isLoading) {
      return [
        Container(
          child: CircularProgressIndicator(),
        )
      ];
    }

    if (isDreamAwait) {
      return _getWidgetsDreamAwait();
    } else {
      return _getWidgetsDreamWithFocus(context);
    }
  }

  List<Widget> _getWidgetsDreamAwait() {
    return [
      SpaceWidget(),
      FaIcon(
        FontAwesomeIcons.history,
        size: 30,
        color: AppColors.colorDarkLight,
      ),
      TextUtil.textSubTitle(Translate.i().get.label_on_hold),
      SpaceWidget(),
      InkWell(
        onTap: onTapCreateFocus,
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.colorDarkLight),
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Column(
            children: [
              FaIcon(
                FontAwesomeIcons.rocket,
                size: 20,
                color: AppColors.colorDarkLight,
              ),
              TextUtil.textSubTitle(Translate.i().get.label_create_focus),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _getWidgetsDreamWithFocus(BuildContext context) {
    return [
      SpaceWidget(),
      CicularProgressRevoWidget(
          titleCenter: percentStep,
          titleBottom: Translate.i().get.label_steps,
          value: valueStep??0,
          colorText: Theme.of(context).primaryColorDark,),
      SpaceWidget(),
      CicularProgressRevoWidget(
          titleCenter: percentToday,
          titleBottom: Translate.i().get.label_today,
          value: valueToday??0,
        colorText: Theme.of(context).primaryColorDark,)
    ];
  }
}
