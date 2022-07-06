
import 'package:dremfoo/app/api/extensions/util_extensions.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/detail_dream_store.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/cicular_progress_revo_widget.dart';
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

  DetailDreamStore _detailDreamStore = Modular.get<DetailDreamStore>();

  @override
  Widget build(BuildContext context) {

    String title = Translate.i().get.label_your_week;
    String subTitle = Translate.i().get.label_monitor_goal_daily;
    double percentCompleted = _detailDreamStore.percentWeekCompleted;
    BarChartData mainBarData = mainBarWeekData(context);
    double goalPercent = goalWeek;

    if(!isChartWeek) {
      title = Translate.i().get.label_your_month;
      subTitle = Translate.i().get.label_monitor_goal_month;
      percentCompleted = _detailDreamStore.percentMonthCompleted;
      mainBarData = mainBarMonthData(context);
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
            color: Theme.of(context).primaryColor,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8, top: 25, bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      TextUtil.textChipLight(title, fontSize: 14),
                      TextUtil.textChipLight(subTitle, fontSize: 10),
                      SpaceWidget(),
                      SpaceWidget(),
                      Expanded(
                        child: BarChart(
                          mainBarData,
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
                                child: TextUtil.textChipLight(Translate.i().get.label_goal)
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

  List<BarChartGroupData> showingGroupsDailyGoalWeek(BuildContext context) {
    List<BarChartGroupData> listBarChart = [];

    for (int week = 0; week < 7; week++) {

      List<DailyGoal>? listWeek = listHistWeekDailyGoal?.where((hist) {
        int weekSelect = hist.lastDateCompleted!.toDate().weekday;
        return (weekSelect == 7 ? 0 : weekSelect) == week;
      }).toList();

      listBarChart.add(makeGroupDataWeek(
        context: context,
        numberColum: week,
        countDailyGoal: _detailDreamStore.countDailyGoal,
        listWeek: listWeek,
      ));
    }

    return listBarChart;
  }

  List<BarChartGroupData> showingGroupsDailyGoalMonth(BuildContext context) {
    List<BarChartGroupData> listBarChart = [];

    for (int month = 1; month <= 12; month++) {
      List<DailyGoal>? listMonth = listHistMonthDailyGoal?.where((hist) {
        int monthSelect = hist.lastDateCompleted!.toDate().month;
        return monthSelect == month;
      }).toList();

      listBarChart.add(makeGroupDataMonth(
        context: context,
        numberColum: month,
        countMaxDayMonth: _detailDreamStore.countDailyGoalMaxMonth,
        listMonth: listMonth,
      ));
    }

    return listBarChart;
  }

  static AxisTitles getBottomTitleChartWeeek() {
    return AxisTitles(
      sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 19,
          getTitlesWidget: (double value, TitleMeta meta) {
            const style = TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 8,
            );
            Widget text;
            switch (value.toInt()) {
              case 0:
                text = Text(Translate.i().get.label_week_day_sun, style: style);
                break;
              case 1:
                text = Text(Translate.i().get.label_week_day_mon, style: style);
                break;
              case 2:
                text = Text(Translate.i().get.label_week_day_tue, style: style);
                break;
              case 3:
                text = Text(Translate.i().get.label_week_day_wed, style: style);
                break;
              case 4:
                text = Text(Translate.i().get.label_week_day_thu, style: style);
                break;
              case 5:
                text = Text(Translate.i().get.label_week_day_fri, style: style);
                break;
              case 6:
                text = Text(Translate.i().get.label_week_day_sat, style: style);
                break;
              default:
                text = const Text('', style: style);
                break;
            }
            return SideTitleWidget(
              axisSide: meta.axisSide,
              child: text,
            );
          }
      ),
    );
  }

  static AxisTitles getBottomTitleChartMonth() {
    return AxisTitles(
      sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 19,
          getTitlesWidget: (double value, TitleMeta meta) {
            const style = TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 8,
            );
            Widget text;
            switch (value.toInt()) {
              case 1:
                text = const Text("01", style: style);
                break;
              case 2:
                text = const Text("02", style: style);
                break;
              case 3:
                text = const Text("03", style: style);
                break;
              case 4:
                text = const Text("04", style: style);
                break;
              case 5:
                text = const Text("05", style: style);
                break;
              case 6:
                text = const Text("06", style: style);
                break;
              case 7:
                text = const Text("07", style: style);
                break;
              case 8:
                text = const Text("08", style: style);
                break;
              case 9:
                text = const Text("09", style: style);
                break;
              case 10:
                text = const Text("10", style: style);
                break;
              case 11:
                text = const Text("11", style: style);
                break;
              case 12:
                text = const Text("12", style: style);
                break;
              default:
                text = const Text('', style: style);
                break;
            }
            return SideTitleWidget(
              axisSide: meta.axisSide,
              child: text,
            );
          }
      ),
    );
  }

  BarChartData mainBarWeekData(BuildContext context) {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false)
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false)
        ),
        bottomTitles: getBottomTitleChartWeeek(),
        leftTitles: AxisTitles(
          sideTitles:  SideTitles(
            showTitles: false,
          )
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroupsDailyGoalWeek(context),
      gridData: FlGridData(show: false),
    );
  }

  BarChartData mainBarMonthData(BuildContext context) {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false)
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false)
        ),
        bottomTitles: getBottomTitleChartMonth(),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          )
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroupsDailyGoalMonth(context),
      gridData: FlGridData(show: false),
    );
  }

  BarChartGroupData makeGroupDataMonth({
    required BuildContext context,
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
          variantStart, variantEnd, Theme.of(context).hintColor);

      variantStart = variantEnd;
      variantEnd = variantEnd + variantConst;
      return barChart;
    }).toList();

    return BarChartGroupData(
      x: numberColum,
      barRods: [
        BarChartRodData(
          toY: 1,
          color: barColor,
          width: width,
          borderSide: BorderSide(color: Colors.white, width: 0),
          rodStackItems: listChart,
        ),
      ],
    );
  }

  BarChartGroupData makeGroupDataWeek({
    required BuildContext context,
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
          variantStart, variantEnd,Theme.of(context).hintColor);
      variantStart = variantEnd;
      variantEnd = variantEnd + variantConst;
      indexColor++;
      return barChart;
    }).toList();

    return BarChartGroupData(
      x: numberColum,
      barRods: [
        BarChartRodData(
          toY: 1,
          color: barColor,
          width: width,
          borderSide: BorderSide(color: Colors.white, width: 0),
          rodStackItems: listChart,
        ),
      ],
    );
  }
}
