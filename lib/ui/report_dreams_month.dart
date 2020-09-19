import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:date_util/date_util.dart';
import 'package:dremfoo/model/dream.dart';
import 'package:dremfoo/model/hist_goal_month.dart';
import 'package:dremfoo/model/step_dream.dart';
import 'package:dremfoo/resources/app_colors.dart';
import 'package:dremfoo/utils/text_util.dart';
import 'package:dremfoo/utils/utils.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ReportDreamsMonth extends StatefulWidget {
  List<HistGoalMonth> listHist;

  ReportDreamsMonth.from(this.listHist);

  @override
  _ReportDreamsMonthState createState() => _ReportDreamsMonthState();
}

class _ReportDreamsMonthState extends State<ReportDreamsMonth> {
  var pageViewController = PageController();

  final _controllerAnimStream = StreamController<String>();

  Stream<String> get streamAnim => _controllerAnimStream.stream;
  GlobalKey _globalKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerAnimStream.close();
  }

  @override
  void didUpdateWidget(ReportDreamsMonth oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list =
        widget.listHist.map((hist) => getPageReport(hist)).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: TextUtil.textAppbar("Relatório mensal"),
              pinned: false,
            ),
          ];
        },
        body: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Center(
                  child: Container(
                    margin: EdgeInsets.all(32),
                    child: SmoothPageIndicator(
                      controller: pageViewController, // PageController
                      count: list.length,
                      effect: WormEffect(
                          dotColor: AppColors.colorPrimaryDark,
                          activeDotColor:
                              AppColors.colorAcent), // your preferred effect
                    ),
                  ),
                )
              ],
            ),
            PageView(
              onPageChanged: (index) {
                print(index);
              },
              controller: pageViewController,
              children: list,
            )
          ],
        ),
      ),
    );
  }

  Widget getPageReport(HistGoalMonth hist) {
    //TODO se der problema com mais de um sonho tirar do stream
    if(hist.isWonReward){
      _controllerAnimStream.add("appear");
    }else{
      _controllerAnimStream.add("crying");
    }
    return Stack(
      children: <Widget>[
        RepaintBoundary(
          key: _globalKey,
          child: SingleChildScrollView(
            child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          Utils.string64ToImage(hist.dream.imgDream,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 160),
                          Container(
                            decoration: AppColors.backgroundBoxDecorationImg(),
                            child: TextUtil.textDefault("Sonho em progresso",
                                fontSize: 16),
                            width: double.infinity,
                            height: 100,
                            padding: EdgeInsets.all(12),
                            alignment: Alignment.bottomRight,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(right: 160),
                            child: Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextUtil.textTitulo(hist.dream.dreamPropose),
                    SizedBox(
                      height: 6,
                    ),
                    TextUtil.textDefault(hist.dream.descriptionPropose),
                    Align(
                      alignment: Alignment.topRight,
                      child: Chip(
                        padding: EdgeInsets.all(8),
                        clipBehavior: Clip.antiAlias,
                        elevation: 4,
                        backgroundColor: AppColors.colorYellow,
                        label: TextUtil.textDefault(
                            "${Utils.month(hist.numberMonth)}",
                            fontSize: 16),
                        avatar: CircleAvatar(
                          backgroundColor: AppColors.colorDark,
                          child: Icon(
                            Icons.date_range,
                            color: Colors.white70,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    createChipStep(hist.dream.steps),
                    getStreamAnimation(hist),
                    cardRewardOrInflection(hist),
                    getCountDayCompleted(hist.dream),
                  ],
                ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () => _capturePng(hist.dream),
              child: Icon(
                Icons.share,
                color: AppColors.colorDark,
              ),
              elevation: 8,
            ),
          ),
        ),
      ],
    );
  }

  StreamBuilder<String> getStreamAnimation(HistGoalMonth hist) {

    String pathAnimation = hist.isWonReward ? "medal.flr" : "sad.flr";

    return StreamBuilder(
                      stream: streamAnim,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            padding: EdgeInsets.all(16),
                            width: double.infinity,
                            height: 150,
                            child: FlareActor(
                              Utils.getPathAssetsAnim(pathAnimation),
                              shouldClip: true,
                              animation: snapshot.data,
                              fit: BoxFit.contain,
                              callback: (anim) {
                                if (anim == "appear") {
                                  _controllerAnimStream.add("points");
                                }
                              },
                            ),
                          );
                        }

                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });
  }

  Widget getCountDayCompleted(Dream dream) {
    DateTime dateInit = dream.dateRegister.toDate();
    DateTime dateNow = DateTime.now();

    final countDaysInit =
        DateUtil().daysPastInYear(dateInit.month, dateInit.day, dateInit.year);
    final countDaysNow =
        DateUtil().daysPastInYear(dateNow.month, dateNow.day, dateNow.year);
    final countDays = countDaysNow - countDaysInit;

    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextUtil.textDefault("Já se passaram ",
              fontSize: 14),
          TextUtil.textDefault("$countDays",
              fontSize: 16),
          TextUtil.textDefault(" dias com foco no seu sonho ;)",
              fontSize: 14),
        ],
      ),
    );
  }

  Widget createChipStep(List<StepDream> steps) {
    List<Widget> listWidget = List();

    for (StepDream stepDream in steps) {
      if (stepDream.isCompleted) {
        Chip chip = Chip(
          avatar: CircleAvatar(
            backgroundColor: AppColors.colorDark,
            child: TextUtil.textDefault("${stepDream.position}˚",),
          ),
          label: TextUtil.textDefault(stepDream.step),
          backgroundColor: AppColors.colorPrimary,
        );

        listWidget.add(Container(
            margin: EdgeInsets.only(left: 2, right: 2, top: 1), child: chip));
      }
    }

    if (listWidget.isNotEmpty) {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextUtil.textTitulo("Etapas finalizadas"),
            SizedBox(
              height: 16,
            ),
            Wrap(
              children: listWidget,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Card cardRewardOrInflection(HistGoalMonth hist) {
    String info =
        "Agora aproveita e faça isso com prazer, sem peso na conciência, você cumpriu sua meta.";
    
    if (!hist.isWonReward) {
      info = "Lembre-se agora é a hora de correr atrás, faça seu ponto de esforço.";
      
    }

    String img = hist.isWonReward ? "icon_reward.png" : "icon_inflection.png";
    String msg = hist.isWonReward ? hist.reward : hist.inflection;
    
    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.colorPrimaryLight,
                  child: ClipOval(
                    child: Image.asset(
                      Utils.getPathAssetsImg(img),
                      width: 35,
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 12),
                    child: TextUtil.textTitulo(msg))
              ],
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: TextUtil.textDefault(info),
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List> _capturePng(Dream dream) async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      final image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      _shareImage(byteData, dream);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  Future<void> _shareImage(ByteData bytes, Dream dream) async {
    try {
      await Share.file('Relatório do sonho', 'sonho_progresso.png',
          bytes.buffer.asUint8List(), 'image/png',
          text: 'Progresso do sonho ${dream.dreamPropose}');
    } catch (e) {
      print('error: $e');
    }
  }
}
