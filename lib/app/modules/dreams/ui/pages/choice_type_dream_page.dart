import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/choice_type_dream_store.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
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
        backgroundColor: AppColors.colorBackground,
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  pinned: true,
                  title: TextUtil.textAppbar("Escolha do sonho"),
                ),
              ];
            },
            body: Container(
              margin: EdgeInsets.all(24),
              child: ListView(
                children: [
                  InkWell(
                    onTap: () => store.startNewDreamAwait(context),
                    child: Card(
                      color: AppColors.colorDark,
                      elevation: 8,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Image.asset(Utils.getPathAssetsImg("icon_sleeping.png"), scale: 6,),
                            SizedBox(height: 10,),
                            TextUtil.textTitulo("Sonho em espera"),
                            SizedBox(height: 16,),
                            TextUtil.textDefault("Nessa seção, você ainda não precisa definir metas e/ou os passos para a conquista. Apenas definir uma prévia de seu sonho para que seu subconsciente saiba o que você quer."),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24,),
                  InkWell(
                    onTap: () => store.startNewDreamWithFocus(context),
                    child: Card(
                      color: AppColors.colorDark,
                      elevation: 8,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset(Utils.getPathAssetsImg("icon_step_dream.png"), scale: 6,),
                            SizedBox(height: 16,),
                            TextUtil.textTitulo("Sonho com foco"),
                            SizedBox(height: 16,),
                            TextUtil.textDefault("Nesse tipo de sonho, você vai precisar definir passos em diferentes níveis, como se fossem degraus de uma escada, além de criar metas diárias que vão em direção ao seu sonho."),
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