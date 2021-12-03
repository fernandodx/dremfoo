import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CircleAvatarUserRevoWidget extends StatelessWidget {
  final String? urlImage;
  final IconData? icon;
  final double size;

  CircleAvatarUserRevoWidget({
    this.urlImage,
    this.icon,
    this.size = 38});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 19,
      backgroundColor: Colors.white12,
      child: ClipOval(
        child: _getImage(),
      ),
    );
  }

  Widget _getImage() {
    if (urlImage != null) {
      return CachedNetworkImage(width: size, height: size, imageUrl: urlImage!);
    }

    if (icon != null) {
      return FaIcon(
        icon,
        size: size,
        color: AppColors.colorLine,
      );
    }

    return Image(
      width: size,
      height: size,
      image: AssetImage(
        Utils.getPathAssetsImg("icon_user_not_found.png"),
      ),
    );
  }
}
