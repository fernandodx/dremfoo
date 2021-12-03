import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ItemUserRankWidget extends StatelessWidget {

  final int position;
  final String? urlImageUser;
  final String nameUser;
  final int daysFocus;
  final String urlIconLevel;


  ItemUserRankWidget({
      required this.position,
      required this.urlImageUser,
      required this.nameUser,
      required this.daysFocus,
      required this.urlIconLevel});

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Container(
          child: TextUtil.textSubTitle("$position˚", fontSize: 17),
          margin: EdgeInsets.only(top: 40, left: 16),
        ),
        Container(
          padding: EdgeInsets.only(left: 45, right: 24, top: 12),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45.0),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    child: _getImage(urlImageUser),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextUtil.textDefault(nameUser, color: AppColors.colorDarkLight,),
                        SizedBox(height: 5,),
                        Wrap(
                          children: [
                            FaIcon(FontAwesomeIcons.bullseye, color: AppColors.colorDark, size: 15,),
                            SizedBox(width: 5,),
                            TextUtil.textDefault("$daysFocus Dias", color: AppColors.colorDark, fontSize: 12)
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.colorDarkLight,
                      child: ClipOval(
                        child: CachedNetworkImage(width: 20, height: 20, imageUrl: urlIconLevel),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getImage(String? urlImage){
    if(urlImage != null){
      return ClipOval(
        child: CachedNetworkImage(width: 40, height: 40, imageUrl: urlImage),
      );
    }else{
      return CircleAvatar(
        radius: 20,
        backgroundImage: AssetImage(
          Utils.getPathAssetsImg("icon_user_not_found.png"),
        ),
      );
    }
  }
}
