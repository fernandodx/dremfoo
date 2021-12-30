import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/home/domain/stories/rank_store.dart';
import 'package:dremfoo/app/modules/home/ui/widgets/item_user_rank_widget.dart';
import 'package:dremfoo/app/modules/home/ui/widgets/top_3_rank_widget.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/alert_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class RankPage extends StatefulWidget {

  @override
  RankPageState createState() => RankPageState();
}
class RankPageState extends ModularState<RankPage, RankStore> {

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
      if(isLoading){
        Overlay.of(context)!.insert(overlayLoading);
      }else{
        overlayLoading.remove();
      }
    });

    reaction<MessageAlert?>((_) => store.msgAlert, (msgErro) {
      if (msgErro != null) {
        alertBottomSheet(context, msg: msgErro.msg, title: msgErro.title, type: msgErro.type);
      }
    });

    store.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translate.i().get.label_rank),
      ),
      body: Observer(
        builder: (context) {
          return ListView(
            children: getBody(),
          );
        },
      )
    );
  }

  List<Widget> getBody() {
    List<Widget> list = [];
    if(store.listUserRevoRank.isNotEmpty){
      list.add(Top3RankWidget(listTop3User: store.listUserRevoRank));
      list.addAll(createListItensRankAfterTop3());
    }
    return list;
  }

  List<Widget> createListItensRankAfterTop3(){
    List<Widget> list = [];
    int position = 4;
    for(UserRevo user in  store.listUserRevoRank.sublist(3)){
      list.add(ItemUserRankWidget(
          position: position,
          urlImageUser: user.urlPicture,
          nameUser: user.name != null ? user.name! : user.email!,
          daysFocus: user.focus!.countDaysFocus!,
          urlIconLevel: user.focus!.level!.urlIcon!)
      );
      position++;
    }
    return list;
  }


}