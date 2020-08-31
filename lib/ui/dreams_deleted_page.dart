import 'package:dremfoo/bloc/dreams_deleted_bloc.dart';
import 'package:dremfoo/eventbus/main_event_bus.dart';
import 'package:dremfoo/model/dream.dart';
import 'package:dremfoo/model/response_api.dart';
import 'package:dremfoo/model/step_dream.dart';
import 'package:dremfoo/resources/app_colors.dart';
import 'package:dremfoo/utils/text_util.dart';
import 'package:dremfoo/utils/utils.dart';
import 'package:dremfoo/widget/app_button_default.dart';
import 'package:dremfoo/widget/app_drawer_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DreamsDeletedPage extends StatefulWidget {
  @override
  _DreamsDeletedPageState createState() => _DreamsDeletedPageState();
}

class _DreamsDeletedPageState extends State<DreamsDeletedPage> {
  final _bloc = DreamsDeletedBloc();

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
      appBar: AppBar(
        title: TextUtil.textAppbar("Sonhos arquivados"),
      ),
      drawer: AppDrawerMenu(),
      body: bodyWithDreamDeleted(),
    );
  }

  Container bodyWithDreamDeleted() {
    return Container(
      color: Colors.white,
      child: FutureBuilder(
        future: _bloc.findDreamsDeleted(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: TextUtil.textTitulo(snapshot.error),
            ); //Criar Tela de erro
          }

          if (snapshot.hasData) {
            List<Dream> listDream = snapshot.data;

            if(listDream == null || listDream.isEmpty){
              return Container(
                child: Center(child: TextUtil.textTitulo("Nenhum sonho foi arquivado, que bom ;)"),),
              );
            }

            return ListView.builder(
              itemCount: listDream.length,
              itemBuilder: (context, index) {
                return _createCard(listDream[index]);
              },
            );
          }

          return _bloc.getSimpleLoadingWidget();
        },
      ),
    );
  }

  Widget _createCard(Dream dream) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: _getImg(dream.imgDream),
                  ),
                  margin: EdgeInsets.all(4),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    child: TextUtil.textTitulo(
                      dream.dreamPropose,
                    ),
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(6),
                  ),
                  Container(
                    child: TextUtil.textDefault(
                      dream.descriptionPropose,
                      fontSize: 14,
                    ),
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(6),
                  ),
                  Container(
                    child: TextUtil.textTitulo("Passos"),
                    padding: EdgeInsets.all(6),
                  ),
                  Wrap(
                    children: createChipStep(dream.steps),
                  ),
                  ButtonBarTheme(
                    data: ButtonBarTheme.of(context),
                    child: ButtonBar(
                      children: <Widget>[
                        AppButtonDefault(
                          onPressed: () => _restoredDream(dream),
                          label: "RESTAURAR",
                          type: TypeButton.FLAT,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        elevation: 6,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }

  _getImg(String imgBase64) {
    return Utils.string64ToImage(
      imgBase64,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 200.0,
    );
  }

  List<Widget> createChipStep(List<StepDream> steps) {
    List<Widget> listWidget = List();

    for (StepDream stepDream in steps) {
      Chip chip = Chip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.colorDark,
          child: TextUtil.textDefault("${stepDream.position}˚",
              color: Colors.white),
        ),
        label: TextUtil.textDefault(stepDream.step, color: Colors.white),
        backgroundColor: AppColors.colorPrimary,
      );

      listWidget.add(Container(
          margin: EdgeInsets.only(left: 2, right: 2, top: 1), child: chip));
    }

    return listWidget;
  }

  _restoredDream(Dream dream) {
    setState(() {
      _bloc.restoredDream(dream);
      MainEventBus().get(context).sendEventHomeDream(TipoEvento.FETCH);
    });
  }
}
