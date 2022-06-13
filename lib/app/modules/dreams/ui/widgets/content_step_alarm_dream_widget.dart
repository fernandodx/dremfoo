
import 'package:dremfoo/app/api/extensions/util_extensions.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/alarm_dream.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';

class ContentStepAlarmDreamWidget extends StatelessWidget {
  final Widget expansionInfo;
  final AlarmDream? alarmDream;
  final Function(TimeOfDay) onTimeSelected;
  final Function(bool) onChangeEnableNotification;
  final Function(int, bool) onChangeWeekDayEnable;

  ContentStepAlarmDreamWidget(
      {required this.expansionInfo,
      required this.alarmDream,
      required this.onTimeSelected,
      required this.onChangeEnableNotification,
      required this.onChangeWeekDayEnable});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          value: alarmDream?.isActive ?? false,
          onChanged: onChangeEnableNotification,
          title: TextUtil.textDefault(Translate.i().get.label_notify_goals),
        ),
        SpaceWidget(),
        Visibility(
          visible: alarmDream?.isActive ?? true,
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  TimeOfDay timeNow = TimeOfDay.now();
                  TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: timeNow.hour, minute: timeNow.minute));
                  if (time != null) {
                    onTimeSelected.call(time);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      width: 1.4,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextUtil.textDefault(Translate.i().get.label_hour),
                      TextUtil.textDefault(
                          "${alarmDream?.time?.toDate().hour.zeroLeft() ?? "--"} : ${alarmDream?.time?.toDate().minute.zeroLeft() ?? "--"} ")
                    ],
                  ),
                ),
              ),
              SpaceWidget(),
              TextUtil.textDefault(Translate.i().get.label_days_of_week),
              SpaceWidget(),
              CheckboxListTile(
                value: alarmDream?.isSunday ?? false,
                onChanged: (value) => onChangeWeekDayEnable.call(DateTime.sunday, value ?? false),
                title: TextUtil.textDefault(Translate.i().get.label_sunday),
              ),
              CheckboxListTile(
                value: alarmDream?.isMonday ?? false,
                onChanged: (value) => onChangeWeekDayEnable.call(DateTime.monday, value ?? false),
                title: TextUtil.textDefault(Translate.i().get.label_monday),
              ),
              CheckboxListTile(
                value: alarmDream?.isTuesday ?? false,
                onChanged: (value) => onChangeWeekDayEnable.call(DateTime.tuesday, value ?? false),
                title: TextUtil.textDefault(Translate.i().get.label_tuesday),
              ),
              CheckboxListTile(
                value: alarmDream?.isWednesday ?? false,
                onChanged: (value) =>
                    onChangeWeekDayEnable.call(DateTime.wednesday, value ?? false),
                title: TextUtil.textDefault(Translate.i().get.label_wednesday),
              ),
              CheckboxListTile(
                value: alarmDream?.isThursday ?? false,
                onChanged: (value) => onChangeWeekDayEnable.call(DateTime.thursday, value ?? false),
                title: TextUtil.textDefault(Translate.i().get.label_thursday),
              ),
              CheckboxListTile(
                value: alarmDream?.isFriday ?? false,
                onChanged: (value) => onChangeWeekDayEnable.call(DateTime.friday, value ?? false),
                title: TextUtil.textDefault(Translate.i().get.label_friday),
              ),
              CheckboxListTile(
                value: alarmDream?.isSaturdays ?? false,
                onChanged: (value) => onChangeWeekDayEnable.call(DateTime.saturday, value ?? false),
                title: TextUtil.textDefault(Translate.i().get.label_saturday),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
