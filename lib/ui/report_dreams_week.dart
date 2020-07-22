import 'package:dremfoo/model/dream.dart';
import 'package:dremfoo/model/hist_goal_month.dart';
import 'package:dremfoo/model/hist_goal_week.dart';
import 'package:dremfoo/resources/app_colors.dart';
import 'package:dremfoo/utils/text_util.dart';
import 'package:dremfoo/utils/utils.dart';
import 'package:dremfoo/widget/app_button_default.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ReportDreamsWeek extends StatefulWidget {

  List<HistGoalWeek> listHist;
  ReportDreamsWeek.from(this.listHist);

  @override
  _ReportDreamsWeekState createState() => _ReportDreamsWeekState();
}

class _ReportDreamsWeekState extends State<ReportDreamsWeek> {
  var pageViewController = PageController();

  @override
  Widget build(BuildContext context) {

    List<Widget> list = widget.listHist.map((hist) => getPageReport(hist)).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share), onPressed: () => print("Compatilhar"))
        ],
        title: TextUtil.textAppbar("Relatório"),
      ),
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
    );
  }

  Widget getPageReport(HistGoalWeek hist) {
  
//    Dream dream = Dream();
//    dream.dreamPropose = "Ir no Tomorrowland";
//    dream.imgDream =
//        "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";
//    hist.dream = dream;
//    hist.numberWeek = 54;
//    hist.reward = "Beber uma nova cerveja.";
//    hist.inflection = "Fazer mais exercicios.";
//    hist.isWonReward = false;

    String info = "Agora aproveita e faça isso com prazer, sem peso na conciência, você cumpriu sua meta.";
    if(!hist.isWonReward){
      info = "Lembre-se agora é a hora de correr atrás, faça seu ponto de esforço.";
    }

    return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextUtil.textTitulo(hist.dream.dreamPropose,
                align: TextAlign.center),
            SizedBox(
              height: 20,
            ),
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Utils.string64ToImage(hist.dream.imgDream,
                    fit: BoxFit.cover,
                    height: 150,
                    width: MediaQuery.of(context).size.width),
              ),
              margin: EdgeInsets.all(4),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Chip(
                elevation: 4,
                backgroundColor: AppColors.colorPrimaryDark,
                label: TextUtil.textDefault("Semana", color: Colors.white),
                avatar: CircleAvatar(
                  backgroundColor: AppColors.colorDark,
                  child: TextUtil.textDefault("${hist.numberWeek}",
                      color: Colors.white),
                ),
              ),
            ),
            Container(
              width: 150,
              height: 150,
              child: FlareActor(
                Utils.getPathAssetsAnim("bell.flr"),
                shouldClip: true,
                animation: "Notification Loop",
                fit: BoxFit.contain,
              ),
            ),
            cardRewardOrInflection(hist),
            SizedBox(height: 20,),
            TextUtil.textDefault(info),
            SizedBox(height: 20,),
          ],
        ));
  }

  Card cardRewardOrInflection(HistGoalWeek hist) {

    String img = hist.isWonReward ?  "icon_reward.png" : "icon_inflection.png";
    String msg = hist.isWonReward ?  hist.reward : hist.inflection;
    return Card(
            elevation: 4,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
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
            ),
          );
  }
}
