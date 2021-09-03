import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';

class OutlineButtonWithImageWidget extends StatelessWidget {
  late String urlImage;
  late String title;
  late String subTitle;

  OutlineButtonWithImageWidget({required this.urlImage, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
        border: Border.all(color: AppColors.colorLine, width: 1.5),
      ),
      width: MediaQuery.of(context).size.width / 2.5,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white12,
              child: ClipOval(
                child: CachedNetworkImage(
                    width: 23,
                    height: 23,
                    imageUrl: urlImage),
              ),
            ),
            margin: EdgeInsets.only(right: 8),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextUtil.textSubTitle(title, color: AppColors.colorTextLight, fontWeight: FontWeight.bold),
              TextUtil.textSubTitle(subTitle, color: AppColors.colorTextLight),
            ],
          ),
        ],
      ),
    );
  }
}
