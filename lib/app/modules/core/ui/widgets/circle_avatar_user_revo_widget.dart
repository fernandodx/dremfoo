import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CircleAvatarUserRevoWidget extends StatelessWidget {
  final String? urlImage;
  final IconData? icon;
  final Image? image;
  final double size;
  final double radiusSize;
  final bool isShowEdit;

  CircleAvatarUserRevoWidget({this.urlImage, this.icon, this.size = 38, this.isShowEdit = false, this.image, this.radiusSize = 19});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        CircleAvatar(
          radius: radiusSize,
          backgroundColor: AppColors.colorDarkLight,
          child: ClipOval(
            child: _getImage(),
          ),
        ),
        Visibility(
          visible: isShowEdit,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FaIcon(
                FontAwesomeIcons.pencilAlt, color: Theme.of(context).canvasColor,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _getImage() {

    if(image != null && image?.image != null) {
      return CircleAvatar(
        radius: 43,
        backgroundImage: image!.image,
      );
    }

    if (urlImage != null) {
      return CachedNetworkImage(width: size, height: size, imageUrl: urlImage!, fit: BoxFit.cover,);
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
      fit: BoxFit.cover,
      image: AssetImage(
        Utils.getPathAssetsImg("icon_user_not_found.png"),
      ),
    );
  }
}
