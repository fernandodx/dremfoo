import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/app_controller.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/circle_avatar_user_revo_widget.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dremfoo/app/api/extensions/util_extensions.dart';

class Top3RankWidget extends StatelessWidget {

  final List<UserRevo>? listTop3User;
  Top3RankWidget({this.listTop3User});

  @override
  Widget build(BuildContext context) {
    if(listTop3User == null ){
      return Container(
        child: Center(child: CircularProgressIndicator(),),
      );
    }

    UserRevo user1 = listTop3User![0];
    UserRevo user2 = listTop3User![1];
    UserRevo user3 = listTop3User![2];

    String nameUser1 = user1.name != null ? user1.name! : user1.email!;
    String nameUser2 = user2.name != null ? user2.name! : user2.email!;
    String nameUser3 = user3.name != null ? user3.name! : user3.email!;

    Color colorIcon = AppController.getInstance().isThemeDark() ? Theme.of(context).accentColor : Theme.of(context).primaryColorDark;


    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
      color: Theme.of(context).backgroundColor.withOpacity(0.6),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      CircleAvatarUserRevoWidget(urlImage: user2.urlPicture, radiusSize: 33, size: 60,),
                      TextUtil.textSubTitle(nameUser2.truncate(length: 14, omission: "..."), fontSize: 12),
                      SizedBox(height: 5,),
                      Wrap(
                        children: [
                          FaIcon(FontAwesomeIcons.bullseye, color: colorIcon, size: 15,),
                          SizedBox(width: 5,),
                          TextUtil.textDefault("${user2.focus!.countDaysFocus} ${Translate.i().get.label_days}", fontSize: 12,)
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                    alignment: Alignment.topCenter,
                    child: CircleAvatar(
                      radius: 13,
                      child: TextUtil.textDefault("2˚"),
                    )
                )
              ],
            ),
          ),
          Container(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 18),
                  child: Column(
                    children: [
                      CircleAvatarUserRevoWidget(urlImage: user1.urlPicture, radiusSize: 43, size: 80,),
                      TextUtil.textSubTitle(nameUser1.truncate(length: 14, omission: "...") , fontSize: 12),
                      SizedBox(height: 5,),
                      Wrap(
                        children: [
                          FaIcon(FontAwesomeIcons.bullseye, color: colorIcon, size: 15,),
                          SizedBox(width: 5,),
                          TextUtil.textDefault("${user1.focus!.countDaysFocus} ${Translate.i().get.label_days}", fontSize: 12)
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: FaIcon(FontAwesomeIcons.crown, color: AppColors.colorYellow, ),
                )
              ],
            ),
          ),
          Container(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      CircleAvatarUserRevoWidget(urlImage: user3.urlPicture, radiusSize: 33, size: 60,),
                      TextUtil.textSubTitle(nameUser3.truncate(length: 14, omission: "...") , fontSize: 12),
                      SizedBox(height: 5,),
                      Wrap(
                        children: [
                          FaIcon(FontAwesomeIcons.bullseye, color: colorIcon, size: 15,),
                          SizedBox(width: 5,),
                          TextUtil.textDefault("${user3.focus!.countDaysFocus} ${Translate.i().get.label_days}", fontSize: 12)
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                    alignment: Alignment.topCenter,
                    child: CircleAvatar(
                      radius: 13,
                      child: TextUtil.textDefault("3˚"),
                    )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getImage(String? urlImage, double size){
    if(urlImage != null){
      return ClipOval(
        child: CachedNetworkImage(width: size, height: size, imageUrl: urlImage),
      );
    }else{
      return CircleAvatar(
        radius: size/2,
        backgroundImage: AssetImage(
          Utils.getPathAssetsImg("icon_user_not_found.png"),
        ),
      );
    }
  }
}
