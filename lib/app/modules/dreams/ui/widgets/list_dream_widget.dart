import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/header_item_dream_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/panel_info_dream_expansion_header_widget.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';

import 'body_item_dream_widget.dart';

class ListDreamWidget extends StatelessWidget {
  final List<Dream> listDream;
  final AnimationController controller;
  final Function(Dream) onTapDetailDream;

  ListDreamWidget(
      {required this.listDream,
      required this.controller,
        required this.onTapDetailDream,});

  createListView() {
    List<Widget> children = [];

    listDream.forEach((dream) {

      children.add(Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderItemDreamWidget(
              percentStep: "40%",
              percentToday: "10%",
              valueToday: 0.1,
              valueStep: 0.4,
              imageBase64: dream.imgDream,
              onTapImage: () {
                onTapDetailDream(dream);
              },
            ),
            SpaceWidget(),
            TextUtil.textSubTitle(dream.dreamPropose ?? "", fontSize: 12, fontWeight: FontWeight.bold),
            TextUtil.textDefault(dream.descriptionPropose ??"", fontSize: 12),
            SpaceWidget(),
            SpaceWidget(),
          ],
        ),
      ));
    });

    return ListView(
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return createListView();
  }
}
