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
            "Já se passaram ",
            fontSize: 14,
          ),
          TextUtil.textDefault(
            "$countDays",
            fontSize: 16,
          ),
          TextUtil.textDefault(
            " dias com foco no seu sonho ;)",
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}
