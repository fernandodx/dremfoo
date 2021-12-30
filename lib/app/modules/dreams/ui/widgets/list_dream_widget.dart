import 'package:dremfoo/app/model/daily_goal.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/no_items_found_widget.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/header_item_dream_widget.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:dremfoo/app/api/extensions/util_extensions.dart';

class ListDreamWidget extends StatelessWidget {
  final List<Dream> listDream;
  final AnimationController controller;
  final Function(Dream) onTapDetailDream;
  final Function(Dream) onTapCreateFocusDream;
  final bool isLoadingStepDaily;

  ListDreamWidget({
    required this.listDream,
    required this.controller,
    required this.onTapDetailDream,
    required this.onTapCreateFocusDream,
    required this.isLoadingStepDaily,
  });

  createListView() {

    if(listDream.isEmpty) {
      return NoItemsFoundWidget(Translate.i().get.msg_not_found_dream);
    }

    List<Widget> children = [];

    listDream.forEach((dream) {

      children.add(Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderItemDreamWidget(
              isLoading: isLoadingStepDaily,
              percentStep: dream.percentStep?.toIntPercent??"0%",
              percentToday: _checkPercentUpdatedToday(dream) ? dream.percentToday?.toIntPercent??"0%" : "0%",
              valueToday: _checkPercentUpdatedToday(dream) ? dream.percentToday : 0,
              valueStep: dream.percentStep,
              imageBase64: dream.imgDream,
              onTapImage: () {
                onTapDetailDream(dream);
              },
              isDreamAwait: dream.isDreamWait??false,
              onTapCreateFocus: () {
                onTapCreateFocusDream(dream);
              },
            ),
            SizedBox(height: 8,),
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

  bool _checkPercentUpdatedToday(Dream dream){
    if(dream.dateUpdate != null
      && dream.dateUpdate!.toDate().isSameDate(DateTime.now())){
      return  true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return createListView();
  }
}
