import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/status_dream_week.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/body_item_report_dream_widget.dart';
import 'package:flutter/material.dart';


class ReportDreamPageViewWidget extends StatelessWidget {

  final PageController pageController;
  final List<StatusDreamPeriod> listStatusPeriod;
  final int numberPeriod;
  final String descriptionNumber;
  final Function(String?) callbackAnimation;
  final String nameAnimation;
  final String pathAnimation;

  ReportDreamPageViewWidget({
      required this.listStatusPeriod,
      required this.pageController,
      required this.numberPeriod,
      required this.descriptionNumber,
      required this.callbackAnimation,
      required this.nameAnimation,
      required this.pathAnimation});

  @override
  Widget build(BuildContext context) {

    List<Widget> pages = [];

    for(StatusDreamPeriod statusPeriod in listStatusPeriod) {

      var dream = statusPeriod.dream!;

      var pageDream = BodyItemReportDreamWidget(
          imgBase64: dream.imgDream!,
          nameDream: dream.dreamPropose!,
          descriptionDream: dream.descriptionPropose!,
          descriptionNumber: descriptionNumber,
          listStepDream: dream.steps,
          callbackAnim: callbackAnimation,
          dateRegisterDream: dream.dateRegister!,
          period: statusPeriod,
          pathAnimation: pathAnimation,
          nameAnimation: nameAnimation);

      pages.add(pageDream);
    }

    return  PageView(
      onPageChanged: (index) {
        print(index);
      },
      controller: pageController,
      children: pages,
    );
  }
}
