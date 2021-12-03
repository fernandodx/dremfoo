import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/no_items_found_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/dream_completed_store.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/widget/alert_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class DreamCompletedPage extends StatefulWidget {
  @override
  DreamCompletedPageState createState() => DreamCompletedPageState();
}
class DreamCompletedPageState extends ModularState<DreamCompletedPage, DreamCompletedStore> {

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
        alertBottomSheet(context,
            msg: msgErro.msg, title: msgErro.title, type: msgErro.type);
      }
    });

    store.fetch();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextUtil.textAppbar("Sonhos realizados"),
      ),
      body: Observer(
        builder: (context) {
          return _getBody();
        },
      )
    );
  }

  Widget _getBody() {
    if(store.listDreamCompleted.isNotEmpty){
      return ListView.builder(
          itemCount: store.listDreamCompleted.length,
          itemBuilder: (context, index) {
            Dream _dream = store.listDreamCompleted[index];
            return _createCard(_dream);
          });
    }else{
      return NoItemsFoundWidget("Ainda nenhum sonho foi realizado, mas tenho certeza que em breve vai ter.");
    }
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
                    child: _getImg(dream.imgDream!),
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
                      dream.dreamPropose!,
                      color: AppColors.colorDark
                    ),
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(6),
                  ),
                  Container(
                    child: TextUtil.textDefault(
                      dream.descriptionPropose!,
                      fontSize: 14,
                        color: AppColors.colorDark
                    ),
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(6),
                  ),
                  Container(
                    child: TextUtil.textTitulo("Passos",   color: AppColors.colorDark),
                    padding: EdgeInsets.all(6),
                  ),
                  Wrap(
                    children: createChipStep(dream.steps!),
                  ),
                  // ButtonBarTheme(
                  //   data: ButtonBarTheme.of(context),
                  //   child: ButtonBar(
                  //     children: <Widget>[
                  //       AppButtonDefault(
                  //         onPressed: () => _restoredDream(dream),
                  //         label: "RESTAURAR",
                  //         type: TypeButton.FLAT,
                  //       )
                  //     ],
                  //   ),
                  // ),
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
    List<Widget> listWidget = [];

    for (StepDream stepDream in steps) {
      Chip chip = Chip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.colorChipSecundary,
          child: TextUtil.textChip("${stepDream.position}˚",),
        ),
        label: TextUtil.textChip(stepDream.step!),
        backgroundColor: AppColors.colorChipPrimary,
      );

      listWidget.add(Container(
          margin: EdgeInsets.only(left: 2, right: 2, top: 1), child: chip));
    }

    return listWidget;
  }
}