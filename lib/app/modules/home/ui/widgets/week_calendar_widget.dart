import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';

class WeekCalendarWidget extends StatelessWidget {
  Function(DateTime) onTapDay;
  DateTime dateTimeSelectec;

  WeekCalendarWidget({required this.onTapDay, required this.dateTimeSelectec});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: getDaysOfWeekRow(context),
    );
  }

  int weekdayFirsdaySunday(int weekday) {
    if (weekday == 7) {
      return 1;
    } else {
      return weekday + 1;
    }
  }

  List<Widget> getDaysOfWeekRow(context) {
    List<Widget> listWidget = [];
    DateTime now = DateTime.now();
    DateTime firstDay = now.subtract(Duration(days: now.weekday));

    for (var i = 1; i <= 7; i++) {
      bool isdayEnable = i <= weekdayFirsdaySunday(now.weekday);
      DateTime dateWeek = firstDay.toLocal();
      bool isSelected = weekdayFirsdaySunday(dateTimeSelectec.weekday) == i;

      ChoiceChip chip = ChoiceChip(
        elevation: 2,
        visualDensity: VisualDensity.compact,
        label: TextUtil.textChipLight(firstDay.day.toString(), fontSize: 10),
        backgroundColor:
            isdayEnable ? Theme.of(context).hintColor : Theme.of(context).disabledColor,
        selectedColor: Theme.of(context).focusColor,
        selected: isSelected,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        onSelected: (selected) {
          if (isdayEnable) {
            onTapDay(dateWeek);
          }
        },
      );

      var borderSelected = BoxDecoration(
          border: Border.all(color: Theme.of(context).accentColor, width: 1),
          borderRadius: BorderRadius.circular(30));
      var borderNormal = BoxDecoration();

      var dayContainer = Container(
        child: InkWell(
          onTap: () {
            if (isdayEnable) {
              onTapDay(dateWeek);
            }
          },
          child: Column(
            children: [
              TextUtil.textChipLight(Utils.weekday(firstDay.weekday, true),
                  fontSize: 10, color: Theme.of(context).accentColor),
              chip
            ],
          ),
        ),
        padding: EdgeInsets.all(6),
        decoration: isSelected ? borderSelected : borderNormal,
      );

      listWidget.add(dayContainer);

      firstDay = firstDay.add(Duration(days: 1));
    }

    return listWidget;
  }
}
