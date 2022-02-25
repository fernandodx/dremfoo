import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/status_dream_week.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';

class CardRewardOrInflectionWidget extends StatelessWidget {

  TypeStatusDream typeStatusDream;
  String descriptionAction;
  CardRewardOrInflectionWidget({required this.typeStatusDream, required this.descriptionAction});

  @override
  Widget build(BuildContext context) {

    String info =
        "Agora aproveita e faça isso com prazer, sem peso na conciência, você cumpriu sua meta.";

    String img = "icon_reward.png";

    if (typeStatusDream != TypeStatusDream.REWARD) {
      info = "Lembre-se agora é a hora de correr atrás, faça seu ponto de esforço.";
      img = "icon_inflection.png";
    }

    return  Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(6),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Theme.of(context).canvasColor,
                  child: ClipOval(
                    child: Image.asset(
                      Utils.getPathAssetsImg(img),
                      width: 35,
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 12),
                    child: TextUtil.textTitulo(descriptionAction))
              ],
            ),
            Container(
              padding: EdgeInsets.all(12),
              child: TextUtil.textDefault(info),
            ),
          ],
        ),
      ),
    );
  }
}
