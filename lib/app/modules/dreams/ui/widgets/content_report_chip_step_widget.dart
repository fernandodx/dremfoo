import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';

class ContentReportChipStepWidget extends StatelessWidget {

  final List<StepDream>? listStep;
  ContentReportChipStepWidget({required this.listStep});

  @override
  Widget build(BuildContext context) {

    List<Widget> listWidget = [];

    if(listStep != null && listStep!.isNotEmpty) {
      for (StepDream stepDream in listStep!) {
        if (stepDream.isCompleted!) {
          Chip chip = Chip(
            avatar: CircleAvatar(
              backgroundColor: Theme.of(context).canvasColor,
              child: TextUtil.textChip(
                "${stepDream.position}˚",
              ),
            ),
            label: TextUtil.textChip(
              stepDream.step!,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          );

          listWidget.add(Container(margin: EdgeInsets.only(left: 2, right: 2, top: 1), child: chip));
        }
      }
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextUtil.textTitulo(Translate.i().get.label_completed_steps),
            SizedBox(
              height: 8,
            ),
            Wrap(
              children: listWidget,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
