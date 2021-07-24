import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:date_util/date_util.dart';
import 'package:dremfoo/app/api/firebase_service.dart';
import 'package:dremfoo/app/model/dream.dart';
import 'package:dremfoo/app/model/step_dream.dart';
import 'package:dremfoo/app/model/user.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/utils/utils.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DreamCompletedPage extends StatefulWidget {
  Dream dream;

  DreamCompletedPage(this.dream);

  @override
  _DreamCompletedPageState createState() => _DreamCompletedPageState();
}

class _DreamCompletedPageState extends State<DreamCompletedPage> {
  GlobalKey _globalKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: TextUtil.textAppbar("Relatório do sonho"),
              pinned: false,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.share), onPressed: () => _capturePng(widget.dream)),
              ],
            ),
          ];
        },
        body: RepaintBoundary(
          key: _globalKey,
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        Utils.string64ToImage(widget.dream.imgDream,
                            fit: BoxFit.cover, width: double.infinity),
                        Container(
                          decoration: AppColors.backgroundBoxDecorationImg(),
                          child: TextUtil.textDefault("Sonho conquistado",
                              fontSize: 16),
                          width: double.infinity,
                          height: 100,
                          padding: EdgeInsets.all(12),
                          alignment: Alignment.bottomRight,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(right: 150),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextUtil.textTitulo(widget.dream.dreamPropose),
                  SizedBox(
                    height: 6,
                  ),
                  TextUtil.textDefault(widget.dream.descriptionPropose),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: double.infinity,
                    height: 120,
                    alignment: Alignment.center,
                    child: FlareActor(
                      Utils.getPathAssetsAnim("trophy.flr"),
                      shouldClip: true,
                      animation: "go",
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  FutureBuilder(
                      future: FirebaseService().getPrefsUser(),
                      builder: (context, snapshot) {
                        String urlImg = "";
                        String nameUser = "";
                        if (snapshot.hasData) {
                          UserRevo user = snapshot.data;
                          urlImg = user.urlPicture;
                          nameUser = user.name;
                        }
                        return Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: NetworkImage(urlImg.isEmpty
                                    ? "https://cdn3.iconfinder.com/data/icons/avatars-15/64/_Bearded_Man-17-512.png"
                                    : urlImg),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              TextUtil.textTitulo("Parabéns $nameUser"),
                            ]);
                      }),
                  Container(
                    color: AppColors.colorPrimaryDark,
                    width: double.infinity,
                    height: 1.5,
                    margin: EdgeInsets.only(top: 16, bottom: 16),
                  ),
                  TextUtil.textTitulo("Etapas conquistadas"),
                  Container(
                    margin: EdgeInsets.only(top: 16, bottom: 16),
                    child: Wrap(
                      children: createChipStep(widget.dream.steps),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  getCountDayCompleted(widget.dream),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getCountDayCompleted(Dream dream) {
    DateTime dateInit = dream.dateRegister.toDate();
    DateTime dateNow = DateTime.now();

    final countDaysInit =
        DateUtil().daysPastInYear(dateInit.month, dateInit.day, dateInit.year);
    final countDaysNow =
        DateUtil().daysPastInYear(dateNow.month, dateNow.day, dateNow.year);
    final countDays = countDaysNow - countDaysInit;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextUtil.textDefault("Sonho realizado em: ",
            fontSize: 20),
        TextUtil.textDefault("$countDays",
            fontSize: 22),
        TextUtil.textDefault(" dias :)",
            fontSize: 20),
      ],
    );
  }

  List<Widget> createChipStep(List<StepDream> steps) {
    List<Widget> listWidget = List();

    for (StepDream stepDream in steps) {
      Chip chip = Chip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.colorChipSecundary,
          child: TextUtil.textChip("${stepDream.position}˚",),
        ),
        label: TextUtil.textChip(stepDream.step),
        backgroundColor: AppColors.colorChipPrimary,
      );

      listWidget.add(Container(
          margin: EdgeInsets.only(left: 2, right: 2, top: 1), child: chip));
    }

    return listWidget;
  }

  Future<Uint8List> _capturePng(Dream dream) async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      final image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      _shareImage(byteData, dream);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }


  Future<void> _shareImage(ByteData bytes, Dream dream) async {
    try {
      await Share.file('Relatório do sonho', 'sonho_realizado.png',
          bytes.buffer.asUint8List(), 'image/png',
          text: 'Parabéns pela realização do sonho ${dream.dreamPropose}');
    } catch (e) {
      print('error: $e');
    }
  }


}
