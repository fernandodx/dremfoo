import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/detail_dream_store.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/cicular_progress_revo_widget.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dremfoo/app/api/extensions/util_extensions.dart';

class ChartWeekWidget extends StatelessWidget {



  final List<DailyGoal>? listHistWeekDailyGoal;
  ChartWeekWidget({required this.listHistWeekDailyGoal});

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
    return Container(
        width: double.maxFinite,
        height: 250,
        child: AspectRatio(
          aspectRatio: 1,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18)),
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
                      TextUtil.textTitulo("Sua Semana"),
                      TextUtil.textSubTitle("Acompanhamento diário das metas", color: AppColors.colorGreen),
                     SpaceWidget(),
                      SpaceWidget(),
                      Expanded(
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                          child: BarChart(
                            mainBarData(),
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
                    child: CicularProgressRevoWidget(
                        radius: 55,
                        titleCenter: _detailDreamStore.percentWeekCompleted.toIntPercent,
                        value: _detailDreamStore.percentWeekCompleted),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  List<BarChartGroupData> showingGroupsDailyGoal() {
    List<BarChartGroupData> listBarChart = [];

    for (int week = 0; week < 7; week++) {

      List<DailyGoal>? listWeek = listHistWeekDailyGoal?.where((hist) {
        int weekSelect = hist.lastDateCompleted!.toDate().weekday;
        return (weekSelect == 7 ? 0 : weekSelect) == week;
      }).toList();

      listBarChart.add(makeGroupData(
        numberColum: week,
        countDailyGoal: _detailDreamStore.countDailyGoal,
        listWeek: listWeek,
      ));
    }

    return listBarChart;
  }

  BarChartData mainBarData() {
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
                return 'DOM';
              case 1:
                return 'SEG';
              case 2:
                return 'TER';
              case 3:
                return 'QUA';
              case 4:
                return 'QUI';
              case 5:
                return 'SEX';
              case 6:
                return 'SAB';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(showTitles: false,),
      ),
      borderData: FlBorderData(show: false,),
      barGroups: showingGroupsDailyGoal(),
      gridData: FlGridData(show: false),
    );
  }

  BarChartGroupData makeGroupData(
      {
        required int numberColum,
        required List<DailyGoal>? listWeek,
        int countDailyGoal = 1,
        Color barColor = Colors.white,
        double width = 15,
      }) {

    int indexColor = 0;
    double variantConst = 1/countDailyGoal;
    double variantEnd = 1/countDailyGoal;
    double variantStart = 0;

    List<BarChartRodStackItem>? listChart = listWeek?.map(
            (dailyHist) {
              var barChart = BarChartRodStackItem(variantStart, variantEnd, availableColors[indexColor]);
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