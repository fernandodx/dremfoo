import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/api/firebase_service.dart';
import 'package:dremfoo/app/api/eventbus/main_event_bus.dart';
import 'package:dremfoo/app/api/eventbus/user_event_bus.dart';
import 'package:dremfoo/app/model/user_focus.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/ui/config_notification_page.dart';
import 'package:dremfoo/app/ui/dreams_completed_page.dart';
import 'package:dremfoo/app/ui/dreams_deleted_page.dart';
import 'package:dremfoo/app/ui/home_page.dart';
import 'package:dremfoo/app/ui/info_media_social_page.dart';
import 'package:dremfoo/app/ui/list_video_page.dart';
import 'package:dremfoo/app/ui/login_page.dart';
import 'package:dremfoo/app/utils/analytics_util.dart';
import 'package:dremfoo/app/utils/nav.dart';
import 'package:dremfoo/app/utils/remoteconfig_util.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawerMenu extends StatefulWidget {
  String urlImgBackgound;

  AppDrawerMenu(
      {this.urlImgBackgound =
          "https://i0.wp.com/errejotanoticias.com.br/wp-content/uploads/2019/12/Divulgação-Foto-da-exposição-Canoa-Havaiana.jpeg?fit=880%2C660&ssl=1"});

  @override
  _AppDrawerMenuState createState() => _AppDrawerMenuState();
}

class _AppDrawerMenuState extends State<AppDrawerMenu> {
  @override
  void initState() {
    super.initState();
    FirebaseService().checkFocusContinuos(context);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: AppColors.backgroundDrawerDecoration(),
        child: ListView(
          children: <Widget>[
            StreamBuilder<User>(
                stream: MainEventBus().get(context).streamUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _userAccountHeader(context, snapshot.data!);
                  }
                  return _userAccountHeader(
                      context, FirebaseAuth.instance.currentUser!);
                }),
            SizedBox(
              height: 16.0,
            ),
            itemMenu(
              context,
              Icons.home,
              "Painel",
              () {
                AnalyticsUtil.sendAnalyticsEvent(EventRevo.menuPainel);
                push(context, HomePage(), isReplace: true);
              },
            ),
            Visibility(
                visible: RemoteConfigUtil().isEnableMenuArchive(),
                child: itemMenu(
                  context,
                  Icons.delete,
                  "Sonhos arquivados",
                  () {
                    AnalyticsUtil.sendAnalyticsEvent(
                        EventRevo.menuDreamDeleted);
                    push(context, DreamsDeletedPage(), isReplace: true);
                  },
                )),
            Visibility(
              visible: RemoteConfigUtil().isEnableMenuDreamCompleted(),
              child: itemMenu(
                context,
                Icons.cloud_done,
                "Sonhos realizados",
                () {
                  AnalyticsUtil.sendAnalyticsEvent(
                      EventRevo.menuDreamCompleted);
                  push(context, DreamsCompletedPage(), isReplace: true);
                },
              ),
            ),
            Visibility(
              visible: RemoteConfigUtil().isEnableMenuNotificacao(),
              child: itemMenu(
                context,
                Icons.notifications,
                "Notificações",
                () {
                  AnalyticsUtil.sendAnalyticsEvent(EventRevo.menuNotification);
                  push(context, ConfigNotificationPage(), isReplace: true);
                },
              ),
            ),
            Visibility(
              visible: RemoteConfigUtil().isEnableMenuVideoRevo(),
              child: itemMenuWithSubTitle(
                context,
                Icons.live_tv,
                "Conteúdo gratuito - REVO",
                "Aprenda a criar hábitos com os videos",
                () {
                  AnalyticsUtil.sendAnalyticsEvent(EventRevo.menuYoutube);
                  push(context, ListVideoPage(), isReplace: true);
                },
              ),
            ),
            Visibility(
              visible: RemoteConfigUtil().isEnableMenuSocialMedia(),
              child: itemMenuWithSubTitle(
                context,
                Icons.people,
                "Redes Sociais",
                "Nos siga nos nossos canais de comunicação",
                () {
                  AnalyticsUtil.sendAnalyticsEvent(EventRevo.menuMediaSocial);
                  push(context, InfoMediaSocialPage(), isReplace: true);
                },
              ),
            ),
            Visibility(
              visible: RemoteConfigUtil().isEnableMenuShare(),
              child: itemMenuWithSubTitle(context, Icons.share, "Compartilhe",
                  "Compartilhe Revo e nos ajude", () {
                AnalyticsUtil.sendAnalyticsEvent(EventRevo.menuShare);
                share();
              }),
            ),
            itemMenu(
              context,
              Icons.exit_to_app,
              "Sair",
              () {
                AnalyticsUtil.sendAnalyticsEvent(EventRevo.menuExit);
                exit(context);
              },
            )
          ],
        ),
      ),
    );
  }

  ListTile itemMenu(
      BuildContext context, IconData icon, String title, Function onTap) {
    return ListTile(
      dense: false,
      leading: CircleAvatar(
        maxRadius: 18,
        backgroundColor: AppColors.colorIconDrawer,
        child: Icon(
          icon,
          color: AppColors.colorlight,
          size: 18,
        ),
      ),
      title: TextUtil.textTitleMenu(title),
      onTap: onTap as void Function()?,
    );
  }

  ListTile itemMenuWithSubTitle(
    BuildContext context,
    IconData icon,
    String title,
    String subTitle,
    Function onTap,
  ) {
    return ListTile(
      dense: false,
      leading: CircleAvatar(
        maxRadius: 18,
        backgroundColor: AppColors.colorIconDrawer,
        child: Icon(
          icon,
          color: AppColors.colorlight,
          size: 18,
        ),
      ),
      title: TextUtil.textTitleMenu(title),
      subtitle: TextUtil.textSubTitleMenu(subTitle),
      onTap: onTap as void Function()?,
    );
  }

  _userAccountHeader(BuildContext context, User user) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          margin: EdgeInsets.only(top:16),
          child: UserAccountsDrawerHeader(
            decoration: AppColors.backgroundDrawerHeaderDecoration(),
            accountName: Text(user.displayName ?? "", style: TextStyle(color: AppColors.colorlight),),
            accountEmail: Text(user.email!, style: TextStyle(color: AppColors.colorlight),),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppColors.colorlight,
              radius: 55,
              child: CircleAvatar(
                radius: 34,
                backgroundImage: ((user.photoURL != null && user.photoURL!.isNotEmpty) ?  NetworkImage(user.photoURL!) :  AssetImage(Utils.getPathAssetsImg("icon_user_not_found.png"))) as ImageProvider<Object>?,
              ),
            ),
          ),
        ),
        StreamBuilder(
          stream: UserEventBus().get(context).streamLevel,
          builder: (BuildContext context, AsyncSnapshot<UserFocus> snapshot) {
            if (snapshot.hasData) {
              UserFocus userFocus = snapshot.data!;
              if (userFocus.level!.urlIcon != null) {
                return getAreaLevel(context, userFocus);
              }
            }
            return Container();
          },
        ),
      ],
    );
  }

  Widget getAreaLevel(BuildContext context, UserFocus userFocus) {
    return Container(
        margin: EdgeInsets.only(right: 16, top: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
          border: Border.all(color: AppColors.colorlight, width: 1.5),
        ),
        width: MediaQuery.of(context).size.width / 2.5,
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: Colors.white12,
                  child: ClipOval(
                    child: CachedNetworkImage(
                        width: 20,
                        height: 20,
                        imageUrl: userFocus.level!.urlIcon!),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                TextUtil.textLight("Nível ${userFocus.level!.name}",
                    fontSize: 13),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.hourglass_empty,
                    color: AppColors.colorlight,
                    size: 15,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  TextUtil.textLight(getDaysFocusStr(userFocus),
                      fontSize: 11),
                ],
              ),
            )
          ],
        ));
  }

  String getDaysFocusStr(UserFocus userFocus) {
    int countDays = userFocus.countDaysFocus!;
    return (countDays > 1)
        ? "$countDays dias de foco"
        : "$countDays dia de foco";
  }

  Future<void> share() async {
    // await FlutterShare.share(
    //     title: 'App Revo',
    //     text:
    //         'Olha esse app, ele vai te ajudar a realizar seus sonhos, através de metas com foco ;)',
    //     linkUrl: 'https://play.google.com/store/apps/details?id=br.com.dias.dremfoo',
    //     chooserTitle: 'Revo  - Foco com metas');

    // Share.share('Olha esse app, ele vai te ajudar a realizar seus sonhos, através de metas com foco: https://play.google.com/store/apps/details?id=br.com.dias.dremfoo', subject: 'Revo  - Foco com metas');


  }

  exit(context) {
    FirebaseService().logout();
    FirebaseService().removeUserPref();
    push(context, LoginPage(), isReplace: true);
  }
}
