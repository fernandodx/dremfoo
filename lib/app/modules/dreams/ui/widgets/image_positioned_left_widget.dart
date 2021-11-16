import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ImagePositionedLeftWidget extends StatelessWidget {
  final String? imageBase64;
  final double leftPercent;
  final double height;
  final Function()? onTap;
  final bool isDreamAwait;

  ImagePositionedLeftWidget(
      {this.imageBase64,
      required this.leftPercent,
      required this.height,
      this.onTap,
      required this.isDreamAwait});

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
                child: Utils.string64ToImage(imageBase64!,
                    width: double.maxFinite, fit: BoxFit.cover),
              ),
            ),
            Container(
              child: isDreamAwait
                  ? FaIcon(
                      FontAwesomeIcons.edit,
                      size: 23,
                      color: Colors.white,
                    )
                  : FaIcon(
                      FontAwesomeIcons.chartBar,
                      size: 23,
                      color: Colors.white,
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
