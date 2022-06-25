import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/card_feature_only_users_subscriber_widget.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/home/domain/stories/presentation_daily_planning_store.dart';
import 'package:dremfoo/app/modules/home/ui/widgets/chip_button_widget.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';

import '../../../../utils/text_util.dart';
import '../../../../utils/utils.dart';
import '../../../core/ui/widgets/alert_bottom_sheet.dart';

class PresentationDailyPlanning extends StatefulWidget {
  const PresentationDailyPlanning({Key? key}) : super(key: key);

  @override
  State<PresentationDailyPlanning> createState() => _PresentationDailyPlanningState();
}

class _PresentationDailyPlanningState extends ModularState<PresentationDailyPlanning, PresentationDailyPlanningStore> {
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
      if (isLoading) {
        Overlay.of(context)!.insert(overlayLoading);
      } else {
        overlayLoading.remove();
      }
    });

    reaction<MessageAlert?>((_) => store.msgAlert, (msgErro) {
      if (msgErro != null) {
        alertBottomSheet(context, msg: msgErro.msg, title: msgErro.title, type: msgErro.type);
      }
    });

    store.fetch(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextUtil.textAppbar(Translate.i().get.label_how_to_plan_day),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
             CardFeatureOnlyUsersSubscriberWidget(),
              SpaceWidget(),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  Utils.getPathAssetsImg(
                    "planning_daily.png",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              SpaceWidget(),
              Card(
                elevation: 4,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Observer(builder: (context) => Column(
                    children: [
                      TextUtil.textDefault(Translate.i().get.msg_experience_productivity,
                          align: TextAlign.justify),
                      ListTile(
                        title:
                            TextUtil.textSubTitle(Translate.i().get.msg_have_more_time),
                        leading: FaIcon(
                          FontAwesomeIcons.hourglassStart,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                      ListTile(
                        title: TextUtil.textSubTitle(Translate.i().get.msg_produce_more),
                        leading: FaIcon(
                          FontAwesomeIcons.arrowTrendUp,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                      ListTile(
                        title:
                            TextUtil.textSubTitle(Translate.i().get.msg_increase_clarity),
                        leading: FaIcon(
                          FontAwesomeIcons.lightbulb,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                      SpaceWidget(),
                      Visibility(
                        visible: store.isPeriodFreeFinish == false,
                        child: ChipButtonWidget(
                          name: Translate.i().get.label_free_trial_7_days,
                          icon: FontAwesomeIcons.calendarCheck,
                          size: double.maxFinite,
                          fontSize: 17,
                          onTap: () => store.initTestFree(context),
                        ),
                      ),
                      Visibility(
                        visible: store.isPeriodFreeFinish == false,
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: TextUtil.textSubTitle(Translate.i().get.label_or, align: TextAlign.center, fontSize: 16),
                        ),
                      ),
                      ChipButtonWidget(
                        name: Translate.i().get.label_subscribe_revo,
                        icon: FontAwesomeIcons.creditCard,
                        size: double.maxFinite,
                        fontSize: 17,
                        onTap: () => Navigator.pushReplacementNamed(context, "/home/subscriptionPlan"),
                      ),
                    ],
                  ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
