import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:flutter/material.dart';

class ImagePositionedLeftWidget extends StatelessWidget {
  final String urlImage;
  final double leftPercent;
  final double height;
  final Function()? onTap;

  ImagePositionedLeftWidget(
      {required this.urlImage,
      required this.leftPercent,
      required this.height,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);

    return AnimatedPositioned(
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                width: double.maxFinite,
                imageUrl: urlImage,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              child: Icon(
                Icons.settings,
                color: Colors.white,
                size: 28,
              ),
              width: double.maxFinite,
              alignment: Alignment.topRight,
              margin: EdgeInsets.all(16),
            ),
          ],
        ),
      ),
      width: deviceInfo.size.width * leftPercent,
      height: height,
      duration: Duration(seconds: 1),
    );
  }
}
