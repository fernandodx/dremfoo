import 'package:dremfoo/app/model/video.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/home/domain/stories/free_videos_store.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/widget/alert_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FreeVideosPage extends StatefulWidget {
  final String title;

  const FreeVideosPage({Key? key, this.title = 'FreeVideosPage'}) : super(key: key);

  @override
  FreeVideosPageState createState() => FreeVideosPageState();
}

class FreeVideosPageState extends ModularState<FreeVideosPage, FreeVideosStore> {

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
        alertBottomSheet(context, msg: msgErro.msg, title: msgErro.title, type: msgErro.type);
      }
    });

    store.featch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextUtil.textAppbar(Translate.i().get.label_free_content),
      ),
      body: Container(
        color: Colors.white,
        child: Observer(
          builder: (context) {
            if (store.listVideo.length > 0) {
              return ListView.builder(
                  itemCount: store.listVideo.length,
                  itemBuilder: (BuildContext context, int index) {
                    Video video = store.listVideo[index];
                    return getCardVideo(video, index);
                  });
            }

            return Container();
          },
        ),
      ),
    );
  }


  Widget getCardVideo(Video video, int index) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          fit: StackFit.passthrough,
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              fit: StackFit.passthrough,
              children: <Widget>[
                Container(
                  child: YoutubePlayer(
                    controller: store.controllers[index],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getUrlImgVideo(String? id) => "https://img.youtube.com/vi/$id/hqdefault.jpg";

}
