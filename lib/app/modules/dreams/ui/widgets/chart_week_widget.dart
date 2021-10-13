import 'package:dremfoo/app/api/extensions/util_extensions.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/detail_dream_store.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/cicular_progress_revo_widget.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChartWeekWidget extends StatelessWidget {

  final List<DailyGoal>? listHistWeekDailyGoal;
  final List<DailyGoal>? listHistMonthDailyGoal;
  final double goalWeek;
  final double goalMonth;
  final bool isChartWeek;

  ChartWeekWidget(
      {required this.listHistWeekDailyGoal,
      required this.listHistMonthDailyGoal,
      required this.isChartWeek,
        this.goalWeek = 0,
        this.goalMonth = 0});

  final List<Color> availableColors = [
    Colors.greenAccent,
    Colors.lightGreen,
    Colors.lightGreenAccent,
    Colors.green,
    Colors.blueGrey,
    Colors.redAccent,
  ];

  DetailDreamStore _detailDreamStore = Modular.get<DetailDreamStore>();

  @override
  Widget build(BuildContext context) {

    String title = Translate.i().get.label_your_week;
    String subTitle = Translate.i().get.label_monitor_goal_daily;
    double percentCompleted = _detailDreamStore.percentWeekCompleted;
    BarChartData mainBarData = mainBarWeekData();
    double goalPercent = goalWeek;

    if(!isChartWeek) {
      title = Translate.i().get.label_your_month;
      subTitle = Translate.i().get.label_monitor_goal_month;
      percentCompleted = _detailDreamStore.percentMonthCompleted;
      mainBarData = mainBarMonthData();
      goalPercent = goalMonth;
    }

    if(percentCompleted.isNaN){
      percentCompleted = 0;
    }

    return Container(
        width: double.maxFinite,
        height: 250,
        child: AspectRatio(
          aspectRatio: 1,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            color: const Color(0xff81e5cd),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      TextUtil.textTitulo(title),
                      TextUtil.textSubTitle(subTitle,
                          color: AppColors.colorGreen),
                      SpaceWidget(),
                      SpaceWidget(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: BarChart(
                            mainBarData,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Stack(
                          children: [
                            CicularProgressRevoWidget(
                                isHalf: true,
                                radius: 55,
                                titleCenter:
                                goalPercent.formatIntPercent,
                                value: goalPercent/100),

                            Container(
                                margin: EdgeInsets.only(top: 35, left: 12),
                                child: TextUtil.textSubTitle(Translate.i().get.label_goal)
                            ),
                          ],
                        ),

                        SpaceWidget(isSpaceRow: true,),

                        CicularProgressRevoWidget(
                            radius: 55,
                            titleCenter:
                            percentCompleted.toIntPercent,
                            value: percentCompleted)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  List<BarChartGroupData> showingGroupsDailyGoalWeek() {
    List<BarChartGroupData> listBarChart = [];

    for (int week = 0; week < 7; week++) {

      List<DailyGoal>? listWeek = listHistWeekDailyGoal?.where((hist) {
        int weekSelect = hist.lastDateCompleted!.toDate().weekday;
        return (weekSelect == 7 ? 0 : weekSelect) == week;
      }).toList();

      listBarChart.add(makeGroupDataWeek(
        numberColum: week,
        countDailyGoal: _detailDreamStore.countDailyGoal,
        listWeek: listWeek,
      ));
    }

    return listBarChart;
  }

  List<BarChartGroupData> showingGroupsDailyGoalMonth() {
    List<BarChartGroupData> listBarChart = [];

    for (int month = 1; month <= 12; month++) {
      List<DailyGoal>? listMonth = listHistMonthDailyGoal?.where((hist) {
        int monthSelect = hist.lastDateCompleted!.toDate().month;
        return monthSelect == month;
      }).toList();

      listBarChart.add(makeGroupDataMonth(
        numberColum: month,
        countMaxDayMonth: _detailDreamStore.countDailyGoalMaxMonth,
        listMonth: listMonth,
      ));
    }

    return listBarChart;
  }

  BarChartData mainBarWeekData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          margin: 8,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return Translate.i().get.label_week_day_sun;
              case 1:
                return Translate.i().get.label_week_day_mon;
              case 2:
                return Translate.i().get.label_week_day_tue;
              case 3:
                return Translate.i().get.label_week_day_wed;
              case 4:
                return Translate.i().get.label_week_day_thu;
              case 5:
                return Translate.i().get.label_week_day_fri;
              case 6:
                return Translate.i().get.label_week_day_sat;
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroupsDailyGoalWeek(),
      gridData: FlGridData(show: false),
    );
  }

  BarChartData mainBarMonthData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          margin: 10,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 1:
                return '01';
              case 2:
                return '02';
              case 3:
                return '03';
              case 4:
                return '03';
              case 5:
                return '05';
              case 6:
                return '06';
              case 7:
                return '07';
              case 8:
                return '08';
              case 9:
                return '09';
              case 10:
                return '10';
              case 11:
                return '11';
              case 12:
                return '12';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroupsDailyGoalMonth(),
      gridData: FlGridData(show: false),
    );
  }

  BarChartGroupData makeGroupDataMonth({
    required int numberColum,
    required List<DailyGoal>? listMonth,
    int countMaxDayMonth = 1,
    Color barColor = Colors.white,
    double width = 10,
  }) {
    double variantConst = 1 / countMaxDayMonth;
    double variantEnd = 1 / countMaxDayMonth;
    double variantStart = 0;

    List<BarChartRodStackItem>? listChart = listMonth?.map((dailyHist) {

      var barChart = BarChartRodStackItem(
          variantStart, variantEnd, availableColors[0]);

      variantStart = variantEnd;
      variantEnd = variantEnd + variantConst;
      return barChart;
    }).toList();

    return BarChartGroupData(
      x: numberColum,
      barRods: [
        BarChartRodData(
          y: 1,
          colors: [barColor],
          width: width,
          borderSide: BorderSide(color: Colors.white, width: 0),
          rodStackItems: listChart,
        ),
      ],
    );
  }

  BarChartGroupData makeGroupDataWeek({
    required int numberColum,
    required List<DailyGoal>? listWeek,
    int countDailyGoal = 1,
    Color barColor = Colors.white,
    double width = 15,
  }) {
    int indexColor = 0;
    double variantConst = 1 / countDailyGoal;
    double variantEnd = 1 / countDailyGoal;
    double variantStart = 0;

    List<BarChartRodStackItem>? listChart = listWeek?.map((dailyHist) {
      var barChart = BarChartRodStackItem(
          variantStart, variantEnd, availableColors[indexColor]);
      variantStart = variantEnd;
      variantEnd = variantEnd + variantConst;
      indexColor++;
      return barChart;
    }).toList();

    return BarChartGroupData(
      x: numberColum,
      barRods: [
        BarChartRodData(
          y: 1,
          colors: [barColor],
          width: width,
          borderSide: BorderSide(color: Colors.white, width: 0),
          rodStackItems: listChart,
        ),
      ],
    );
  }
}
