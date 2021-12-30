import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/choice_type_dream_store.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChoiceTypeDreamPage extends StatefulWidget {
  @override
  ChoiceTypeDreamPageState createState() => ChoiceTypeDreamPageState();
}

class ChoiceTypeDreamPageState extends ModularState<ChoiceTypeDreamPage, ChoiceTypeDreamStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  pinned: true,
                  title: TextUtil.textAppbar(Translate.i().get.label_dream_choice),
                ),
              ];
            },
            body: Container(
              margin: EdgeInsets.all(16),
              child: ListView(
                children: [
                  InkWell(
                    onTap: () => store.startNewDreamAwait(context),
                    child: Card(
                      color: Theme.of(context).backgroundColor.withOpacity(0.8),
                      elevation: 8,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Image.asset(Utils.getPathAssetsImg("icon_sleeping.png"), scale: 6,),
                            SizedBox(height: 10,),
                            TextUtil.textTitulo(Translate.i().get.label_dream_hold),
                            SizedBox(height: 16,),
                            TextUtil.textDefault(Translate.i().get.msg_help_dream_hold, align: TextAlign.justify),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  InkWell(
                    onTap: () => store.startNewDreamWithFocus(context),
                    child: Card(
                      color: Theme.of(context).backgroundColor.withOpacity(0.8),
                      elevation: 8,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset(Utils.getPathAssetsImg("icon_step_dream.png"), scale: 6,),
                            SizedBox(height: 16,),
                            TextUtil.textTitulo(Translate.i().get.label_dream_with_focus),
                            SizedBox(height: 16,),
                            TextUtil.textDefault(Translate.i().get.msg_help_dream_with_focus, align: TextAlign.justify),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}