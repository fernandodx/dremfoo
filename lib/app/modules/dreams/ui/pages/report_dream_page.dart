import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/alert_bottom_sheet.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/loading_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dtos/period_report_dto.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/status_dream_week.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/report_dream_week_store.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/report_dream_page_view_widget.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ReportDreamPage extends StatefulWidget {
  final PeriodReportDto period;

  ReportDreamPage({required this.period});

  @override
  _ReportDreamPageState createState() => _ReportDreamPageState();
}

class _ReportDreamPageState extends ModularState<ReportDreamPage, ReportDreamWeekStore> {
  @override
  void initState() {
    super.initState();

    var overlayLoading = OverlayEntry(builder: (context) {
      return Container(
        color: Colors.black38,
        alignment: Alignment.center,
        child: LoadingWidget(Translate.i().get.msg_loading_dream),
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

    store.featch(context, widget.period);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: TextUtil.textAppbar(widget.period.periodStatus == PeriodStatusDream.MONTHLY ? "Relatório Mensal" : "Relatório Semanal"),
              expandedHeight: 110,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                          onTap: () => store.pageViewController.previousPage(
                              duration: Duration(milliseconds: 400), curve: Curves.easeOutQuad),
                          child: FaIcon(FontAwesomeIcons.arrowCircleLeft)),
                      Observer(
                        builder: (context) {

                          if(store.listStatusDreamPeriod.length <= 0){
                            return Container();
                          }

                          return Container(
                            height: 30,
                            child: SmoothPageIndicator(
                              controller: store.pageViewController, // PageController
                              count: store.listStatusDreamPeriod.length,
                              effect: WormEffect(
                                  dotColor: Theme.of(context).canvasColor,
                                  activeDotColor:
                                      Theme.of(context).primaryColorDark), // your preferred effect
                            ),
                          );
                        },
                      ),
                      InkWell(
                          onTap: () => store.pageViewController.nextPage(
                              duration: Duration(milliseconds: 400), curve: Curves.easeOutQuad),
                          child: FaIcon(FontAwesomeIcons.arrowCircleRight)),
                    ],
                  ),
                ),
              ),
              pinned: true,
              floating: false,
            ),
          ];
        },
        body: Flex(
          direction: Axis.vertical,
          children: [
            Observer(
                builder: (context) {

                  if(store.listStatusDreamPeriod.length <= 0){
                    return Container();
                  }

                  return Expanded(
                    child: ReportDreamPageViewWidget(
                      pageController: store.pageViewController,
                      listStatusPeriod: store.listStatusDreamPeriod,
                      numberPeriod: widget.period.numPeriod,
                      descriptionNumber: widget.period.periodStatus == PeriodStatusDream.MONTHLY ? "Mês" : "Semana",
                      callbackAnimation: (anim) {
                        if (anim != null && anim.isNotEmpty && anim == 'appear') {
                          store.setNameAnimation(anim);
                        }
                      },
                      nameAnimation: store.nameAnimation,
                      pathAnimation: 'medal.flr',
                    ),
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}

