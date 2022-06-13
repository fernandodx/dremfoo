import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/date_util.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';

class ContentCountDayDreamCompletedWidget extends StatelessWidget {

  final DateTime dateInit;
  ContentCountDayDreamCompletedWidget({required this.dateInit});

  @override
  Widget build(BuildContext context) {

    DateTime dateNow = DateTime.now();
    final countDaysInit = DateUtil().daysPastInYear(dateInit.month, dateInit.day, dateInit.year);
    final countDaysNow = DateUtil().daysPastInYear(dateNow.month, dateNow.day, dateNow.year);
    final countDays = (countDaysInit - countDaysNow);

    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextUtil.textDefault(
            "${Translate.i().get.label_already_passed} ",
            fontSize: 14,
          ),
          TextUtil.textDefault(
            "$countDays",
            fontSize: 16,
          ),
          TextUtil.textDefault(
            " ${Translate.i().get.label_days_focusing} ;)",
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}
