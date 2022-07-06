import 'package:dremfoo/app/api/extensions/util_extensions.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/alert_bottom_sheet.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/no_items_found_widget.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/status_dream_week.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/cicular_progress_revo_widget.dart';
import 'package:dremfoo/app/modules/home/domain/stories/list_alert_report_goal_dream_store.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';

class ListAlertReportGoalDreamPage extends StatefulWidget {
  const ListAlertReportGoalDreamPage({Key? key}) : super(key: key);

  @override
  _ListAlertReportGoalDreamPageState createState() => _ListAlertReportGoalDreamPageState();
}

class _ListAlertReportGoalDreamPageState
    extends ModularState<ListAlertReportGoalDreamPage, ListAlertReportGoalDreamStore> {
  @override
  void initState() {
    super.initState();

    var overlayLoading = OverlayEntry(builder: (context) {
      return Container(
        color: Colors.black38,
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    });

    reaction<bool>((_) => store.isLoading, (isLoading) {
      if(isLoading){
        Overlay.of(context)!.insert(overlayLoading);
      }else{
        overlayLoading.remove();
      }
    });

    reaction<MessageAlert?>((_) => store.msgAlert, (msgErro) {
      if (msgErro != null) {
        alertBottomSheet(context, msg: msgErro.msg, title: msgErro.title, type: msgErro.type);
      }
    });

    store.featch();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: store.initialIndex,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: TextUtil.textAppbar(Translate.i().get.label_dream_notification),
            bottom: TabBar(
              indicatorColor: Theme.of(context).canvasColor,
              labelStyle: Theme.of(context).textTheme.bodyText1,
              tabs: [
                Tab(
                  icon: FaIcon(
                    FontAwesomeIcons.wrench,
                    size: 18,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  text: Translate.i().get.label_inflection_points,
                ),
                Tab(
                  icon: FaIcon(
                    FontAwesomeIcons.trophy,
                    size: 18,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  text: Translate.i().get.label_rewards,
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                child: Observer(
                  builder: (context) => ExpansionListWeekMonthReportWidget(
                    isInflection: true,
                    listStatusPeriod: store.listStatusInflectionPeriod,
                    expansionCallback: store.updateItemStatusInflectionPeriodIsExpanded,
                    onCheckedPeriod: store.updateReportStatusInflectionPeriod,
                  ),
                ),
              ),
              Container(
                child: Observer(
                  builder: (context) => ExpansionListWeekMonthReportWidget(
                    isInflection: false,
                    listStatusPeriod: store.listStatusRewardPeriod,
                    expansionCallback: store.updateItemStatusRewardPeriodIsExpanded,
                    onCheckedPeriod: store.updateReportStatusRewardPeriod,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class ExpansionListWeekMonthReportWidget extends StatelessWidget {
  List<StatusDreamPeriod> listStatusPeriod;
  ExpansionPanelCallback? expansionCallback;
  bool isInflection;
  Function(bool isChecked, StatusDreamPeriod statusPeriod) onCheckedPeriod;

  ExpansionListWeekMonthReportWidget(
      {required this.listStatusPeriod, this.expansionCallback, required this.onCheckedPeriod, required this.isInflection});

  @override
  Widget build(BuildContext context) {
    if (listStatusPeriod.isEmpty) {
      return Center(
        child: NoItemsFoundWidget(
            Translate.i().get.msg_not_found_report_status),
      );
    }

    return SingleChildScrollView(
      child: Container(
        child: _createPanel(context),
      ),
    );
  }

  Widget _createPanel(context) {
    return ExpansionPanelList(
      expansionCallback: expansionCallback,
      children: listStatusPeriod.map<ExpansionPanel>((status) {
        var periodName = status.periodStatusDream == PeriodStatusDream.WEEKLY ? Translate.i().get.label_week : Translate.i().get.label_month;
        var inflectionOrReward = "";
        var iconInflectionOrReward = FontAwesomeIcons.wrench;
        if(isInflection) {
          inflectionOrReward = PeriodStatusDream.WEEKLY == status.periodStatusDream ? status.dream?.inflectionWeek??"-" :  status.dream?.inflection??"-";
        }else{
          iconInflectionOrReward = FontAwesomeIcons.trophy;
          inflectionOrReward = PeriodStatusDream.WEEKLY == status.periodStatusDream ? status.dream?.rewardWeek??"-" : status.dream?.reward??"-";
        }

        return ExpansionPanel(
          headerBuilder: (BuildContext contex, bool isExpanded) {
            return SwitchListTile(
              value: status.isChecked == true,
              title: TextUtil.textDefault("${status.dream?.dreamPropose}"),
              subtitle: Wrap(
                children: [
                  TextUtil.textChipLight("${periodName} N˚ ${status.number}",
                      color: Theme.of(context).canvasColor),
                  SpaceWidget(
                    isSpaceRow: true,
                  ),
                  Visibility(
                    visible: status.isChecked == true,
                      child: Icon(
                    Icons.check_circle,
                    size: 18,
                    color: Theme.of(context).canvasColor,
                  ))
                ],
              ),
              onChanged: (isChecked) {
                onCheckedPeriod.call(isChecked, status);
              },
            );
          },
          body: Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: FaIcon(
                        iconInflectionOrReward,
                        size: 18,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      radius: 16,
                    ),
                    SpaceWidget(
                      isSpaceRow: true,
                    ),
                    Flexible(
                      child: TextUtil.textSubTitle(inflectionOrReward,
                          fontSize: 14, maxLines: 3),
                    )
                  ],
                ),
                SpaceWidget(),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CicularProgressRevoWidget(
                            isHalf: true,
                            radius: 55,
                            colorText: Theme.of(context).canvasColor,
                            titleCenter: status.difficulty!.formatIntPercent,
                            value: status.difficulty! / 100),
                        Container(
                            margin: EdgeInsets.only(top: 35, left: 12),
                            child: TextUtil.textDefault(Translate.i().get.label_goal)),
                      ],
                    ),
                    SpaceWidget(
                      isSpaceRow: true,
                    ),
                    CicularProgressRevoWidget(
                        radius: 55,
                        colorText: Theme.of(context).canvasColor,
                        titleCenter: status.percentCompleted!.toIntPercent,
                        value: status.percentCompleted! <= 1.0 ? status.percentCompleted! : 1.0),
                  ],
                ),
                Chip(label: TextUtil.textChip("${Translate.i().get.label_year} ${status.year}")),
              ],
            ),
          ),
          isExpanded: status.isExpanded ?? false,
        );
      }).toList(),
    );
  }
}