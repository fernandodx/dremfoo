import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/api/firebase_service.dart';
import 'package:dremfoo/model/response_api.dart';
import 'package:dremfoo/model/video.dart';
import 'package:dremfoo/resources/app_colors.dart';
import 'package:dremfoo/utils/text_util.dart';
import 'package:dremfoo/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

class ListVideoPage extends StatefulWidget {
  @override
  _ListVideoPageState createState() => _ListVideoPageState();
}

class _ListVideoPageState extends State<ListVideoPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: TextUtil.textAppbar("Conteúdo gratuito"),
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder(
            future: FirebaseService().findAllVideos(),
            builder: (BuildContext context,
                AsyncSnapshot<ResponseApi<List<Video>>> snapshot) {
              
              if (snapshot.hasData && snapshot.data.ok) {
               
                List<Video> listVideos = snapshot.data.result;

                return ListView.builder(
                    itemCount: listVideos.length,
                    itemBuilder: (BuildContext context, int index) {
                      Video video = listVideos[index];
                      return InkWell(
                          onTap: () => playVideo(video),
                          child: getCardVideo(listVideos[index]));
                    });
              }

              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }


  Widget getCardVideo(Video video) {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            fit: StackFit.passthrough,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl:
                    getUrlImgVideo(video.id),
                height: 200,
                fit: BoxFit.cover,
              ),
              Icon(
                Icons.play_circle_outline,
                color: Colors.black45,
                size: 80,
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 16, bottom: 18, top: 16, right: 16),
            decoration: AppColors.backgroundBoxDecorationImg(),
            child: TextUtil.textTituloVideo(
                "${video.name} | ${video.time}",
                color: Colors.white,
                align: TextAlign.left),
          ),
          Container(
            padding: EdgeInsets.only(left: 16, bottom: 2, right: 16),
            child: TextUtil.textDefault("Publicado em: ${Utils.dateToString(video.date.toDate())}",
                color: Colors.white70, fontSize: 10, align: TextAlign.right),
          ),
        ],
      ),
    );
  }

  String getUrlImgVideo(String id) => "https://img.youtube.com/vi/$id/hqdefault.jpg";

  void playVideo(Video video){

    FirebaseService().getPrefsUser().then((user){
      video.reference.collection("views").add({"name": user.name, "e-mail": user.email, "date" : Timestamp.now()});
    });

    FlutterYoutube.playYoutubeVideoById(
        apiKey: "AIzaSyDS3-7JYRPr7LlFzSecblTKVvTq_t2cBDw",
        videoId: video.id,
        autoPlay: true,
        //default false
        fullScreen: true,
        backgroundColor: Colors.blueGrey //default false
    );
  }
}
