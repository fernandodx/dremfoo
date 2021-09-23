import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:flutter/material.dart';

class ImagePositionedLeftWidget extends StatelessWidget {
  final String? imageBase64;
  final double leftPercent;
  final double height;
  final Function()? onTap;

  ImagePositionedLeftWidget(
      {this.imageBase64,
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
            Visibility(
              visible: imageBase64 != null && imageBase64!.isNotEmpty,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Utils.string64ToImage(imageBase64!, width: double.maxFinite, fit: BoxFit.cover),
              ),
            ),
            Visibility(
              visible: imageBase64 == null || imageBase64!.isEmpty,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  width: double.maxFinite,
                  imageUrl: "https://www.criandocomapego.com/wp-content/uploads/2018/03/manual-dos-sonhos.jpg",
                  fit: BoxFit.cover,
                ),
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
