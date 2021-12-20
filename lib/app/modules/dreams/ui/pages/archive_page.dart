import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/no_items_found_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/widget/alert_bottom_sheet.dart';
import 'package:dremfoo/app/widget/app_button_default.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/archive_store.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

class ArchivePage extends StatefulWidget {
  final String title;
  const ArchivePage({Key? key, this.title = 'ArchivePage'}) : super(key: key);
  @override
  ArchivePageState createState() => ArchivePageState();
}
class ArchivePageState extends ModularState<ArchivePage, ArchiveStore> {

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
          title: TextUtil.textAppbar(Translate.i().get.label_archived_dreams),
        ),
        body: Observer(
          builder: (context) {
            return _getBody();
          },
        ));
  }

  Widget _getBody() {
    if(store.listDreamArchive.isNotEmpty){
      return ListView.builder(
          itemCount: store.listDreamArchive.length,
          itemBuilder: (context, index) {
            Dream _dream = store.listDreamArchive[index];
            return _createCard(_dream);
          });
    }else{
      return NoItemsFoundWidget(Translate.i().get.msg_dream_not_archived);
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
                    ),
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(6),
                  ),
                  Container(
                    child: TextUtil.textDefault(
                      dream.descriptionPropose!,
                      fontSize: 14,
                    ),
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(6),
                  ),
                  Container(
                    child: TextUtil.textTitulo(Translate.i().get.label_steps),
                    padding: EdgeInsets.all(6),
                  ),
                  Wrap(
                    children: createChipStep(dream.steps!, context),
                  ),
                  ButtonBarTheme(
                    data: ButtonBarTheme.of(context),
                    child: ButtonBar(
                      children: <Widget>[
                        AppButtonDefault(
                          onPressed: () => store.restoredDream(dream),
                          label: Translate.i().get.label_restore,
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

  List<Widget> createChipStep(List<StepDream> steps, BuildContext context) {
    List<Widget> listWidget = [];

    for (StepDream stepDream in steps) {
      Chip chip = Chip(
        avatar: CircleAvatar(
          backgroundColor: Theme.of(context).canvasColor,
          child: TextUtil.textChip("${stepDream.position}˚", color: Theme.of(context).accentColor),
        ),
        label: TextUtil.textChip(stepDream.step!, color: Theme.of(context).canvasColor),
      );

      listWidget.add(Container(
          margin: EdgeInsets.only(left: 2, right: 2, top: 1), child: chip));
    }

    return listWidget;
  }

}