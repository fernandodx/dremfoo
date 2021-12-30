import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/dream_store.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/list_dream_widget.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/alert_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';

class DreamsPage extends StatefulWidget {
  @override
  DreamsPageState createState() => DreamsPageState();
}

class DreamsPageState extends ModularState<DreamsPage, DreamStore>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  List<Dream> listDream = [];

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
        title: TextUtil.textAppbar(Translate.i().get.label_dreams),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 12, right: 12, top: 12),
        child: Observer(
          builder: (context) => ListDreamWidget(
            listDream: store.listDream,
            isLoadingStepDaily: store.isloadingDailyStep,
            controller: _controller,
            onTapDetailDream: (Dream dreamSelected) {
              store.detailDream(context, dreamSelected);
            },
            onTapCreateFocusDream: (Dream dreamSelected) {
              store.createFocusDream(context, dreamSelected);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          store.newDream(context);
        },
        label: Text(Translate.i().get.label_new_dream),
        icon: FaIcon(FontAwesomeIcons.plus, size: 18,),
      ),
    );
  }
}
