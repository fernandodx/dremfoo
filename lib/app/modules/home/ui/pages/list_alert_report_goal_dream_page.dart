import 'package:dremfoo/app/modules/core/ui/widgets/no_items_found_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/status_dream_week.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/expasion_panel_list_info_widget.dart';
import 'package:dremfoo/app/modules/home/domain/stories/list_alert_report_goal_dream_store.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListAlertReportGoalDreamPage extends StatefulWidget {
  const ListAlertReportGoalDreamPage({Key? key}) : super(key: key);

  @override
  _ListAlertReportGoalDreamPageState createState() => _ListAlertReportGoalDreamPageState();
}

class _ListAlertReportGoalDreamPageState extends ModularState<ListAlertReportGoalDreamPage, ListAlertReportGoalDreamStore> {

  @override
  void initState() {
    super.initState();

    store.featch();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: store.initialIndex,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: TextUtil.textAppbar("Notificações dos Sonhos"),
            bottom: TabBar(
              indicatorColor: Theme.of(context).canvasColor,
              labelStyle: Theme.of(context).textTheme.bodyText1,
              tabs: [
                Tab(
                  icon: FaIcon(Icons.build, size: 18, color: Theme.of(context).canvasColor,),
                  text: "Pontos Inflexão",
                ),
                Tab(
                  icon: FaIcon(FontAwesomeIcons.trophy, size: 18, color: Theme.of(context).canvasColor,),
                  text: "Recompensas",
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                child: Observer(
                  builder: (context) => ExpansionListWeekMonthReportWidget(
                    listStatusPeriod: store.listStatusPeriod,
                    expansionCallback: (int index, bool isExpanded) => store.updateItemStatusPeriodIsExpanded(index, isExpanded),
                  ),
                ),
              ),
              Container(
                color: Colors.amber,
              )
            ],
          ),
        ));
  }
}

class ExpansionListWeekMonthReportWidget extends StatelessWidget {

  List<StatusDreamPeriod> listStatusPeriod;
  ExpansionPanelCallback? expansionCallback;
  ExpansionListWeekMonthReportWidget({required this.listStatusPeriod, this.expansionCallback});

  @override
  Widget build(BuildContext context) {
    if(listStatusPeriod.isEmpty){
      return Center(
        child: NoItemsFoundWidget("Não existe ainda ações semanais de recompensa ou pontos de inflexão."),
      );
    }

    return SingleChildScrollView(
      child: Container(
        child: _createPanel(),
      ),
    );
  }

  Widget _createPanel() {
    return ExpansionPanelList(
      expansionCallback: expansionCallback,
      children: listStatusPeriod.map<ExpansionPanel>((status) {
        return ExpansionPanel(
          headerBuilder: (BuildContext contex,  bool isExpanded) {
            return ListTile(
              title: TextUtil.textTitulo("${status.typeStatusDream} ${status.number}"),
            );
          },
          body: Container(
            child: Column(
              children: [
                TextUtil.textSubTitle(status.dream?.descriptionPropose??""),
                Chip(label: TextUtil.textChip("${status.typeStatusDream}")),
              ],
            ),
          ),
          isExpanded: status.isExpanded??false,
        );
      }).toList(),
    );
  }
}


