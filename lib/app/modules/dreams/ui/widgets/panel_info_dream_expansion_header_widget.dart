import 'package:dremfoo/app/modules/dreams/ui/animate_widgets/arrow_animation_widgets.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';

class PanelInfoDreamExpansionHeaderWidget extends StatelessWidget {

  final AnimationController controller;
  final Function()? onTap;

  PanelInfoDreamExpansionHeaderWidget({required this.controller, this.onTap});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextUtil.textSubTitle("Meu sonho", fontSize: 14, fontWeight: FontWeight.bold),
              TextUtil.textDefault("Descrição do Sonho  - dhajh alkshdlasd lkjkljsd lkajsdkl alsdjlajsd alskdjalksjda sdasdjl  ",),
            ],
          ),
        ),
        InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            child: ArrowAnimationWidget(controller: controller,)
        )
      ],
    );
  }
}