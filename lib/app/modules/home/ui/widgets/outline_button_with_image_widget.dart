import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OutlineButtonWithImageWidget extends StatelessWidget {
  late String? urlImage;
  late String title;
  late String? subTitle;
  late IconData? icon;

  OutlineButtonWithImageWidget(
      {this.urlImage, this.icon, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    if((urlImage == null && icon == null) || subTitle == null ) {
      return _getLoading();
    }else{
      return _getBody(context);
    }
  }

  Widget _getLoading() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }


  Widget _getBody(BuildContext context) {
     return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
        border: Border.all(color: Theme.of(context).canvasColor, width: 1.5),
      ),
      width: MediaQuery.of(context).size.width / 2.5,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).canvasColor,
              child: ClipOval(
                child: _getImage(context),
              ),
            ),
            margin: EdgeInsets.only(right: 8),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextUtil.textSubTitle(title, fontWeight: FontWeight.bold),
                TextUtil.textSubTitle(subTitle??""),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getImage(BuildContext context){
    if(urlImage != null){
      return CachedNetworkImage(width: 20, height: 20, imageUrl: urlImage!);
    }else{
      return FaIcon(icon, size: 17, color: Theme.of(context).accentColor.withAlpha(240),);
    }
  }
}
