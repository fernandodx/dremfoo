import 'dart:collection';

import 'package:dremfoo/resources/app_colors.dart';
import 'package:dremfoo/utils/text_util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartGoals {
  double step;
  double percentStepCompleted;
  Color color;
  double levelWeek;
  double levelMonth;

  ChartGoals(this.step, this.percentStepCompleted, this.color, this.levelWeek, this.levelMonth);

  static Widget createChartWeek(
      String titleChart, List<List<ChartGoals>> listDataChart) {
    return AspectRatio(
      aspectRatio: 1.1,
      child: Container(
        margin: EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            colors: const [
              Color(0xff173D4E),
              Color(0xff0D505B),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: EdgeInsets.all(4),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 4,
                ),
                TextUtil.textDefault(titleChart,
                    fontSize: 16,
                    color: Color(0xff8EC786),
                    align: TextAlign.center),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: LineChart(
                      _createLineChart(listDataChart),
                      swapAnimationDuration: const Duration(milliseconds: 850),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static LineChartData _createLineChart(List<List<ChartGoals>> listDataChart) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: false,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 16,
          textStyle: const TextStyle(
            color: Color(0xff8EC786),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          margin: 7,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return 'D';
              case 2:
                return 'S';
              case 3:
                return 'T';
              case 4:
                return 'Q';
              case 5:
                return 'Q';
              case 6:
                return 'S';
              case 7:
                return 'S';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff8EC786),
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0%';
              case 20:
                return '20%';
              case 40:
                return '40%';
              case 60:
                return '60%';
              case 80:
                return '80%';
              case 100:
                return '100%';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: AppColors.colorDarkLight,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: AppColors.colorDarkLight,
          ),
        ),
      ),
      minX: 1,
      maxX: 7,
      maxY: 100,
      minY: 0,
      lineBarsData: _getLinesChart(listDataChart),
    );
  }

  static List<LineChartBarData> _getLinesChart(
      List<List<ChartGoals>> listGoals) {
    List<LineChartBarData> listLineChart = List();

    listGoals.forEach((chartGoals) {
      List<FlSpot> listDataSpots = List();
      Color color = null;

      chartGoals.forEach((dataChart) {
        color = dataChart.color; //Cor gráfico semanal
        listDataSpots.add(FlSpot(dataChart.step, dataChart.percentStepCompleted));
      });

      final LineChartBarData lineChart = LineChartBarData(
        spots: listDataSpots,
        isCurved: true,
        colors: [
          color,
        ],
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      );

      listLineChart.add(lineChart);

      creatLineGoalLevel(chartGoals[0].levelWeek, listLineChart, color);

    });

    return listLineChart;
  }

  static void creatLineGoalLevel(double levelWeek, List<LineChartBarData> listLineChart, Color color) {
     List<FlSpot> listDataSpotsGoal = List();
    for(int i =1; i<=7; i++){
      listDataSpotsGoal.add(FlSpot(i.toDouble(),levelWeek));
    }

    final LineChartBarData lineChartGoal = LineChartBarData(
      spots: listDataSpotsGoal,
      isCurved: false,
      dashArray: [5,5],
      colors: [
        color,
      ],
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );

    listLineChart.add(lineChartGoal);
  }

  static List<BarChartGroupData> createBarGroup(List<ChartGoals> listGoals) {
    final double width = 7;
    final Color leftBarColor = const Color(0xff53fdd7);
    final Color rightBarColor = const Color(0xffff5182);

    List<BarChartGroupData> listGroup = List();

    listGoals.forEach((goalsDream) {
      List<BarChartRodData> barRods = List();
      int x = goalsDream.step.toInt();

      barRods.add(BarChartRodData(
        y: goalsDream.percentStepCompleted,
        color: leftBarColor,
        width: width,
      ));

      listGroup.add(BarChartGroupData(barsSpace: 4, x: x, barRods: barRods));
    });

    return listGroup;
  }

  static HashMap<int, List<BarChartRodData>> createBarRodData(
      double width, int countMouth, List<List<ChartGoals>> listGoals) {
    HashMap<int, List<BarChartRodData>> mapMouth = HashMap();

    listGoals.forEach((goals) {
      for (int mouth = 0; mouth < countMouth; mouth++) {
        List<BarChartRodData> barRods = List();
        if (mapMouth[mouth] != null) {
          barRods = mapMouth[mouth];
        }

        barRods.add(BarChartRodData(
          y: goals[mouth].percentStepCompleted,
          color: goals[mouth].color, //Cor da barra mês
          width: width,
        ));

        mapMouth[mouth] = barRods;
      }
    });

    return mapMouth;
  }

  static List<BarChartGroupData> createBarJoinGroup(
      HashMap<int, List<BarChartRodData>> mapMouth) {
    List<BarChartGroupData> listGroup = List();

    mapMouth.forEach((mouth, listRodData) {
      listGroup
          .add(BarChartGroupData(barsSpace: 4, x: mouth, barRods: listRodData));
    });

    return listGroup;
  }

  static BarChartGroupData makeGroupData(int x, double y1, double y2) {
    final double width = 7;
    final Color leftBarColor = const Color(0xff53fdd7);
    final Color rightBarColor = const Color(0xffff5182);

    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        color: leftBarColor,
        width: width,
      ),
//      BarChartRodData(
//        y: y2,
//        color: rightBarColor,
//        width: width,
//      ),
    ]);
  }

  static Widget createBarChartMouth(List<ChartGoals> listChartGoals) {
    List<BarChartGroupData> rawBarGroups;
    List<BarChartGroupData> showingBarGroups;
    List<int> listGoalMonth = [];

    listChartGoals.forEach((dataChart){
      listGoalMonth.add(dataChart.levelMonth.toInt());
    });

    rawBarGroups = createBarGroup(listChartGoals);
//    rawBarGroups = items;

    showingBarGroups = rawBarGroups;

    showingBarGroups = List.of(rawBarGroups);

    return AspectRatio(
      aspectRatio: 1.1,
      child: Container(
        margin: EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            colors: const [
              Color(0xff173D4E),
              Color(0xff0D505B),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: EdgeInsets.all(4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TextUtil.textDefault("Seu mês (Todas as metas)",
                  color: Color(0xff8EC786),
                  fontSize: 16,
                  align: TextAlign.center),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BarChart(
                    BarChartData(
                      maxY: 100,
                      minY: 0,
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: Color(0xff8EC786),
                              fontWeight: FontWeight.normal,
                              fontSize: 12),
                          margin: 8,
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              case 0:
                                return '1';
                              case 1:
                                return '2';
                              case 2:
                                return '3';
                              case 3:
                                return '4';
                              case 4:
                                return '5';
                              case 5:
                                return '6';
                              case 6:
                                return '7';
                              case 7:
                                return '8';
                              case 8:
                                return '9';
                              case 9:
                                return '10';
                              case 10:
                                return '11';
                              case 11:
                                return '12';
                              default:
                                return '';
                            }
                          },
                        ),
                        rightTitles: SideTitles(
                            showTitles: true,
                            textStyle: TextStyle(
                              fontSize: 16,
                            ),
                          getTitles: (value){
                            if(listGoalMonth.contains(value.toInt())){
                              return "🥳";
                            }
                            return "";
                          }
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: Color(0xff8EC786),
                              fontWeight: FontWeight.normal,
                              fontSize: 12),
                          margin: 32,
                          reservedSize: 16,
                          getTitles: (value) {
                            switch (value.toInt()) {
                              case 0:
                                return '0%';
                              case 20:
                                return '20%';
                              case 40:
                                return '40%';
                              case 60:
                                return '60%';
                              case 80:
                                return '80%';
                              case 100:
                                return '100%';
                              default:
                                return '';
                            }
                          },
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                    ),
                    swapAnimationDuration: Duration(milliseconds: 900),
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget createBarChartJoinMouth(List<List<ChartGoals>> listChartGoals) {
    List<BarChartGroupData> rawBarGroups;
    List<BarChartGroupData> showingBarGroups;
    List<int> listGoalMonth = [];

    listChartGoals.forEach((dataChart){
      listGoalMonth.add(dataChart[0].levelMonth.toInt());
    });

    int countBar = listChartGoals[0].length * listChartGoals.length;
    double width = 12;

    if (countBar > 30) {
      width = 2;
    } else if (countBar > 24) {
      width = 3;
    } else if (countBar > 18) {
      width = 4;
    } else if (countBar > 15) {
      width = 5;
    } else if (countBar > 12) {
      width = 6;
    } else if (countBar > 6) {
      width = 8;
    }

    rawBarGroups = createBarJoinGroup(
        createBarRodData(width, listChartGoals[0].length, listChartGoals));
//    rawBarGroups = items;

    showingBarGroups = rawBarGroups;

    int touchedGroupIndex = -1;
    showingBarGroups = List.of(rawBarGroups);

    return AspectRatio(
      aspectRatio: 1.13,
      child: Container(
        margin: EdgeInsets.only(top: 4, bottom: 8, left: 4, right: 4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            colors: const [
              Color(0xff173D4E),
              Color(0xff0D505B),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: EdgeInsets.all(4),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TextUtil.textDefault("Seu mês",
                  color: Color(0xff8EC786),
                  fontSize: 16,
                  align: TextAlign.center),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BarChart(
                    BarChartData(
                      maxY: 100,
                      minY: 0,
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                            fontSize: 16,
                          ),
                          getTitles: (double value){
                            if(listGoalMonth.contains(value.toInt())){
                              return "🥳";
                            }
                            return "";
                          }
                        ),
                        bottomTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: Color(0xff8EC786),
                              fontWeight: FontWeight.normal,
                              fontSize: 12),
                          margin: 8,
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              case 0:
                                return '1';
                              case 1:
                                return '2';
                              case 2:
                                return '3';
                              case 3:
                                return '4';
                              case 4:
                                return '5';
                              case 5:
                                return '6';
                              case 6:
                                return '7';
                              case 7:
                                return '8';
                              case 8:
                                return '9';
                              case 9:
                                return '10';
                              case 10:
                                return '11';
                              case 11:
                                return '12';
                              default:
                                return '';
                            }
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: Color(0xff8EC786),
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                          margin: 16,
                          reservedSize: 16,
                          getTitles: (value) {
                            switch (value.toInt()) {
                              case 0:
                                return '0%';
                              case 20:
                                return '20%';
                              case 40:
                                return '40%';
                              case 60:
                                return '60%';
                              case 80:
                                return '80%';
                              case 100:
                                return '100%';
                              default:
                                return '';
                            }
                          },
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                    ),
                    swapAnimationDuration: Duration(milliseconds: 900),
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget makeTransactionsIcon() {
    const double width = 4.5;
    const double space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}
