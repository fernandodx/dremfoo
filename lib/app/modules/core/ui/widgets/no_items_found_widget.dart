import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/widgets.dart';

class NoItemsFoundWidget extends StatelessWidget {

  final String msg;
  NoItemsFoundWidget(this.msg);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          child: FlareActor(
            Utils.getPathAssetsAnim("empty_not_found-idle.flr"),
            shouldClip: true,
            animation: "idle",
          ),
        ),
        Container(
          margin: EdgeInsets.all(16),
          child: Center(
            child: TextUtil.textTitulo(msg),
          ),
        ),
      ],
    );
  }
}
