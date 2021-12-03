import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/model/video.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VideoYoutubeWidget extends StatelessWidget {

  final Video? video;


  VideoYoutubeWidget({this.video});

  @override
  Widget build(BuildContext context) {
    if(video == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return _getBody();
  }

  Container _getBody() {
     return Container(
      padding: EdgeInsets.all(6),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: "https://img.youtube.com/vi/${video?.id}/hqdefault.jpg",
                  fit: BoxFit.cover,
                  height: 130,
                  width: double.maxFinite,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              Align(
                child: FaIcon(
                  FontAwesomeIcons.playCircle,
                  color: Colors.white70,
                  size: 80,
                ),
              )
            ],
            alignment: Alignment.center,
          ),
          TextUtil.textSubTitle(
              "${video?.name} | ${video?.time}",
              color: AppColors.colorTextLight)
        ],
      ),
    );
  }
}
