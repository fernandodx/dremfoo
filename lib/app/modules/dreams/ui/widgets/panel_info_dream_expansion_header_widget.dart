import 'package:dremfoo/app/modules/dreams/ui/animate_widgets/arrow_animation_widgets.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';

class PanelInfoDreamExpansionHeaderWidget extends StatelessWidget {

  final AnimationController controller;
  final Function()? onTap;
  final String title;
  final String subTitle;

  PanelInfoDreamExpansionHeaderWidget({required this.controller, this.onTap, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextUtil.textSubTitle(title, fontSize: 12, fontWeight: FontWeight.bold),
                TextUtil.textDefault(subTitle, fontSize: 12),
              ],
            ),
          ),
          InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.all(Radius.circular(40)),
              child: ArrowAnimationWidget(controller: controller,)
          )
        ],
      ),
    );
  }
}