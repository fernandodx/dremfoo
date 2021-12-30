import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/widgets.dart';

class LoadingWidget extends StatelessWidget {

  final String msg;
  LoadingWidget(this.msg);

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
            Utils.getPathAssetsAnim("loading-load.flr"),
            shouldClip: true,
            animation: "load",
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
