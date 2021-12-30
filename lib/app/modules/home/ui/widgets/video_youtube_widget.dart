import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/model/video.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoYoutubeWidget extends StatelessWidget {
  final Video? video;

  VideoYoutubeWidget({
    this.video,
  });

  @override
  Widget build(BuildContext context) {
    if (video == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return _getBody(context);
  }

  Widget _getBody(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialogPlayVideo(context, video!.id!);
      },
      child: Container(
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
            SizedBox(
              height: 8,
            ),
            TextUtil.textSubTitle("${video?.name} | ${video?.time}", align: TextAlign.justify, fontSize: 11)
          ],
        ),
      ),
    );
  }

  void showDialogPlayVideo(BuildContext context, String idVideo) {
    YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId: idVideo,
        flags: YoutubePlayerFlags(
          autoPlay: true,
        ));

    showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26))
        ),
        builder: (context) {
          return Container(
            margin: EdgeInsets.all(16),
            width: double.maxFinite,
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
          );
        });
  }

}
