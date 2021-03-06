import 'package:dremfoo/ui/register_dreams_page.dart';
import 'package:dremfoo/utils/nav.dart';
import 'package:dremfoo/utils/text_util.dart';
import 'package:dremfoo/utils/utils.dart';
import 'package:flutter/material.dart';

class CheckTypeDreamPage extends StatefulWidget {
  @override
  _CheckTypeDreamPageState createState() => _CheckTypeDreamPageState();
}

class _CheckTypeDreamPageState extends State<CheckTypeDreamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    onTap: () => _onTapDreamWait(context),
                    child: Card(
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
                    onTap: () => _onTapDreamWithFoco(context),
                    child: Card(
                      elevation: 8,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Column(
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

  _onTapDreamWithFoco(context) {
    push(context, RegisterDreamPage.fromIsWait(false));
  }

  _onTapDreamWait(context) {
    push(context, RegisterDreamPage.fromIsWait(true));
  }
}
