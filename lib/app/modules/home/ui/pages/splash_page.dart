import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/alert_bottom_sheet.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/loading_widget.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/no_items_found_widget.dart';
import 'package:dremfoo/app/modules/home/domain/stories/splash_store.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class SplashPage extends StatefulWidget {
  final String title;
  const SplashPage({Key? key, this.title = 'Loading...'}) : super(key: key);
  @override
  SplashPageState createState() => SplashPageState();
}
class SplashPageState extends ModularState<SplashPage, SplashStore> {


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
      if(msgErro != null){
        alertBottomSheet(context,
            msg: msgErro.msg,
            title:msgErro.title,
            type: msgErro.type);
      }
    });

    store.featch(context);

  }

  @override
  Widget build(BuildContext context) {

    Translate.i().init(context); //Colocar em um local único

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: LoadingWidget(Translate.i().get.label_loading),
          )
        ],
      ),
    );
  }
}