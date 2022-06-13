import 'dart:collection';

import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartGoals {
  double step;
  double percentStepCompleted;
  Color color;
  double? levelWeek;
  double? levelMonth;

  ChartGoals(this.step, this.percentStepCompleted, this.color, this.levelWeek,
      this.levelMonth);

  static Widget createChartWeek(
      String titleChart, List<List<ChartGoals>> listDataChart) {
    return AspectRatio(
      key: ObjectKey(1),
      aspectRatio: 1.1,
      child: Container(
        margin: EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10),),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 10.0,
            ),
          ],
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
                    fontSize: 14, align: TextAlign.center),
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


  static AxisTitles getBottomTitleChart() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 16,
        getTitlesWidget: (double value, TitleMeta meta) {
          const style = TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          );
          Widget text;
          switch (value.toInt()) {
            case 1:
              text = const Text('D', style: style);
              break;
            case 2:
              text = const Text('S', style: style);
              break;
            case 3:
              text = const Text('T', style: style);
              break;
            case 4:
              text = const Text('Q', style: style);
              break;
            case 5:
              text = const Text('Q', style: style);
              break;
            case 6:
              text = const Text('S', style: style);
              break;
            case 7:
              text = const Text('S', style: style);
              break;
            default:
              text = const Text('', style: style);
              break;
          }
          return SideTitleWidget(
            axisSide: meta.axisSide,
            space: 16,
            child: text,
          );
        }
      ),
    );
  }

  static AxisTitles getLeftTitleChart() {
    return AxisTitles(
      sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 16,
          getTitlesWidget: (double value, TitleMeta meta) {
            const style = TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            );
            Widget text;
            switch (value.toInt()) {
              case 0:
                text = const Text('0%', style: style);
                break;
              case 20:
                text = const Text('20%', style: style);
                break;
              case 40:
                text = const Text('40%', style: style);
                break;
              case 60:
                text = const Text('60%', style: style);
                break;
              case 80:
                text = const Text('80%', style: style);
                break;
              case 100:
                text = const Text('100%', style: style);
                break;
              default:
                text = const Text('', style: style);
                break;
            }
            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 16,
              child: text,
            );
          }
      ),
    );
  }


  static LineChartData _createLineChart(List<List<ChartGoals>> listDataChart) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        handleBuiltInTouches: false,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: getBottomTitleChart(),
        leftTitles: getLeftTitleChart(),
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
    List<LineChartBarData> listLineChart = [];

    listGoals.forEach((chartGoals) {
      List<FlSpot> listDataSpots = [];
      Color? color = null;

      chartGoals.forEach((dataChart) {
        color = dataChart.color; //Cor gráfico semanal
        listDataSpots
            .add(FlSpot(dataChart.step, dataChart.percentStepCompleted));
      });

      final LineChartBarData lineChart = LineChartBarData(
        spots: listDataSpots,
        isCurved: true,
        color: color,
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

  static void creatLineGoalLevel(
      double? levelWeek, List<LineChartBarData> listLineChart, Color? color) {
    List<FlSpot> listDataSpotsGoal = [];
    for (int i = 1; i <= 7; i++) {
      listDataSpotsGoal.add(FlSpot(i.toDouble(), levelWeek!));
    }

    final LineChartBarData lineChartGoal = LineChartBarData(
      spots: listDataSpotsGoal,
      isCurved: false,
      dashArray: [5, 5],
      color: color,
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

    List<BarChartGroupData> listGroup = [];

    listGoals.forEach((goalsDream) {
      List<BarChartRodData> barRods = [];
      int x = goalsDream.step.toInt();

      barRods.add(BarChartRodData(
        toY: goalsDream.percentStepCompleted,
        color: leftBarColor,
        width: width,
      ));

      listGroup.add(BarChartGroupData(barsSpace: 4, x: x, barRods: barRods));
    });

    return listGroup;
  }

  static HashMap<int, List<BarChartRodData>?> createBarRodData(
      double width, int countMouth, List<List<ChartGoals>> listGoals) {
    HashMap<int, List<BarChartRodData>?> mapMouth = HashMap();

    listGoals.forEach((goals) {
      for (int mouth = 0; mouth < countMouth; mouth++) {
        List<BarChartRodData>? barRods = [];
        if (mapMouth[mouth] != null) {
          barRods = mapMouth[mouth];
        }

        barRods!.add(BarChartRodData(
          toY: goals[mouth].percentStepCompleted,
          color: goals[mouth].color,
          width: width,
        ));

        mapMouth[mouth] = barRods;
      }
    });

    return mapMouth;
  }

  static List<BarChartGroupData> createBarJoinGroup(
      HashMap<int, List<BarChartRodData>?> mapMouth) {
    List<BarChartGroupData> listGroup = [];

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
        toY: y1,
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

  static AxisTitles getBottomTitleChartMonth() {
    return AxisTitles(
      sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 16,
          getTitlesWidget: (double value, TitleMeta meta) {
            const style = TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            );
            Widget text;
            switch (value.toInt()) {
              case 1:
                text = const Text('1', style: style);
                break;
              case 2:
                text = const Text('2', style: style);
                break;
              case 3:
                text = const Text('3', style: style);
                break;
              case 4:
                text = const Text('4', style: style);
                break;
              case 5:
                text = const Text('5', style: style);
                break;
              case 6:
                text = const Text('6', style: style);
                break;
              case 7:
                text = const Text('7', style: style);
                break;
              case 8:
                text = const Text('8', style: style);
                break;
              case 9:
                text = const Text('9', style: style);
                break;
              case 10:
                text = const Text('10', style: style);
                break;
              case 11:
                text = const Text('11', style: style);
                break;
              case 12:
                text = const Text('12', style: style);
                break;
              default:
                text = const Text('', style: style);
                break;
            }
            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 16,
              child: text,
            );
          }
      ),
    );
  }

  static AxisTitles getLeftTitleChartMonth() {
    return AxisTitles(
      sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 16,
          getTitlesWidget: (double value, TitleMeta meta) {
            const style = TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            );
            Widget text;
            switch (value.toInt()) {
              case 0:
                text = const Text('0%', style: style);
                break;
              case 20:
                text = const Text('20%', style: style);
                break;
              case 40:
                text = const Text('40%', style: style);
                break;
              case 60:
                text = const Text('60%', style: style);
                break;
              case 80:
                text = const Text('80%', style: style);
                break;
              case 100:
                text = const Text('100%', style: style);
                break;
              default:
                text = const Text('', style: style);
                break;
            }
            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 16,
              child: text,
            );
          }
      ),
    );
  }

  static Widget createBarChartMouth(List<ChartGoals> listChartGoals) {
    List<BarChartGroupData> rawBarGroups;
    List<BarChartGroupData> showingBarGroups;
    List<int> listGoalMonth = [];

    listChartGoals.forEach((dataChart) {
      listGoalMonth.add(dataChart.levelMonth!.toInt());
    });

    rawBarGroups = createBarGroup(listChartGoals);
//    rawBarGroups = items;

    showingBarGroups = rawBarGroups;

    showingBarGroups = List.of(rawBarGroups);

    return AspectRatio(
      key: ObjectKey(2),
      aspectRatio: 1.1,
      child: Container(
        margin: EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 10.0,
            )
          ],
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
                  fontSize: 14, align: TextAlign.center),
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
                        bottomTitles: getBottomTitleChartMonth(),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget:  (double value, TitleMeta meta) {
                                const style = TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                );
                                Widget text;

                                if (listGoalMonth.contains(value.toInt())) {
                                  text = const Text("🥳", style: style);
                                }else{
                                  text = const Text("", style: style);
                                }
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space: 16,
                                  child: text,
                                );
                              }
                            ),
                        ),
                        leftTitles: getLeftTitleChartMonth(),
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

    listChartGoals.forEach((dataChart) {
      listGoalMonth.add(dataChart[0].levelMonth!.toInt());
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
      key: ObjectKey(2),
      aspectRatio: 1.13,
      child: Container(
        margin: EdgeInsets.only(top: 4, bottom: 8, left: 4, right: 4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 10.0,
            )
          ],
        ),
        padding: EdgeInsets.all(4),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TextUtil.textDefault("Seu mês",
                  fontSize: 14, align: TextAlign.center),
              SizedBox(
                height: 2,
              ),
              SizedBox(
                height: 1,
                child: Container(
                  color: AppColors.colorPrimaryDark,
                ),
              ),
              SizedBox(
                height: 14,
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
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget:  (double value, TitleMeta meta) {
                                const style = TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                );
                                Widget text;

                                if (listGoalMonth.contains(value.toInt())) {
                                  text = const Text("🥳", style: style);
                                }else{
                                  text = const Text("", style: style);
                                }
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space: 16,
                                  child: text,
                                );
                              }
                          ),
                        ),
                        bottomTitles: getBottomTitleChartMonth(),
                        leftTitles: getLeftTitleChartMonth(),
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
