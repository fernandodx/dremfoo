import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_util/date_util.dart';
import 'package:dremfoo/api/firebase_service.dart';
import 'package:dremfoo/eventbus/main_event_bus.dart';
import 'package:dremfoo/eventbus/user_event_bus.dart';
import 'package:dremfoo/model/level_revo.dart';
import 'package:dremfoo/model/response_api.dart';
import 'package:dremfoo/model/user.dart';
import 'package:dremfoo/model/user_focus.dart';
import 'package:dremfoo/resources/app_colors.dart';
import 'package:dremfoo/ui/config_notification_page.dart';
import 'package:dremfoo/ui/dreams_deleted_page.dart';
import 'package:dremfoo/ui/home_page.dart';
import 'package:dremfoo/ui/info_media_social_page.dart';
import 'package:dremfoo/ui/list_video_page.dart';
import 'package:dremfoo/ui/login_page.dart';
import 'package:dremfoo/utils/analytics_util.dart';
import 'package:dremfoo/utils/nav.dart';
import 'package:dremfoo/utils/remoteconfig_util.dart';
import 'package:dremfoo/utils/text_util.dart';
import 'package:dremfoo/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

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
                    return _userAccountHeader(context, snapshot.data);
                  }
                  return _userAccountHeader(
                      context, FirebaseAuth.instance.currentUser);
                }),
            SizedBox(
              height: 16.0,
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: TextUtil.textDefault("Painel", color: Colors.white),
              subtitle: TextUtil.textDefault("Acompanhe seus sonhos",
                  color: Colors.white70),
              onTap: () {
                AnalyticsUtil.sendAnalyticsEvent(EventRevo.menuPainel);
                push(context, HomePage(), isReplace: true);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              title: TextUtil.textDefault("Sonhos arquivados",
                  color: Colors.white),
              onTap: () {
                AnalyticsUtil.sendAnalyticsEvent(EventRevo.menuDreamDeleted);
                push(context, DreamsDeletedPage(), isReplace: true);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              title: TextUtil.textDefault("Notificações", color: Colors.white),
              onTap: () {
                AnalyticsUtil.sendAnalyticsEvent(EventRevo.menuNotification);
                push(context, ConfigNotificationPage(), isReplace: true);
              },
            ),
            Visibility(
              visible: RemoteConfigUtil().isEnableMenuVideoRevo(),
              child: ListTile(
                leading: Icon(
                  Icons.live_tv,
                  color: Colors.white,
                ),
                title: TextUtil.textDefault("Conteúdo gratuito - REVO",
                    color: Colors.white),
                subtitle: TextUtil.textDefault(
                    "Série de vídeos por trás do seu funcionamento, aprenda a dominar seus hábitos",
                    color: Colors.white70),
                onTap: () {
                  AnalyticsUtil.sendAnalyticsEvent(EventRevo.menuYoutube);
                  push(context, ListVideoPage(), isReplace: true);
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.people,
                color: Colors.white,
              ),
              title: TextUtil.textDefault("Redes Sociais", color: Colors.white),
              subtitle: TextUtil.textDefault(
                  "Siga nos nas nossos canais de comunicação",
                  color: Colors.white70),
              onTap: () {
                AnalyticsUtil.sendAnalyticsEvent(EventRevo.menuMediaSocial);
                push(context, InfoMediaSocialPage(), isReplace: true);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.share,
                color: Colors.white,
              ),
              title: TextUtil.textDefault("Compartilhe", color: Colors.white),
              subtitle: TextUtil.textDefault(
                  "Compartilhe Revo com os seus amigos",
                  color: Colors.white70),
              onTap: () {
                AnalyticsUtil.sendAnalyticsEvent(EventRevo.menuShare);
                share();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              title: TextUtil.textDefault("Sair", color: Colors.white),
              onTap: () {
                AnalyticsUtil.sendAnalyticsEvent(EventRevo.menuExit);
                exit(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  _userAccountHeader(BuildContext context, User user) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    widget.urlImgBackgound,
                  ))),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaY: 4,
              sigmaX: 4,
            ),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(),
              accountName: Text(user.displayName ?? ""),
              accountEmail: Text(user.email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(user.photoURL ??
                    "https://cdn3.iconfinder.com/data/icons/avatars-15/64/_Bearded_Man-17-512.png"),
              ),
            ),
          ),
        ),
        StreamBuilder(
            stream:  UserEventBus().get(context).streamLevel,
            builder: (context, snapshot){

              if(snapshot.hasData){
                UserFocus userFocus = snapshot.data;
                if(userFocus.level.urlIcon != null){
                  return getAreaLevel(context, userFocus);
                }
              }
              return Container();

            },),
      ],
    );
  }

  Widget getAreaLevel(BuildContext context, UserFocus userFocus) {
    return Container(
        margin: EdgeInsets.only(right: 8, top: 16),
        decoration: BoxDecoration(
             borderRadius: BorderRadius.all(Radius.circular(4),),
            border: Border.all(color: Colors.white, width: 1.5),
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
                  backgroundColor: Colors.white54,
                  child: ClipOval(
                    child: CachedNetworkImage(
                        width: 20,
                        height: 20,
                        imageUrl: userFocus.level.urlIcon),
                  ),
                ),
                SizedBox(width: 10,),
                TextUtil.textDefault("Nível ${userFocus.level.name}", color: Colors.white, fontSize: 13),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.hourglass_empty, color: Colors.white, size: 15,),
                  SizedBox(width: 1,),
                  TextUtil.textDefault(getDaysFocusStr(userFocus), color: Colors.white, fontSize: 11),

                ],
              ),
            )

          ],
        )
      );
  }

  String getDaysFocusStr(UserFocus userFocus){
    int countDays = userFocus.countDaysFocus;
    return (countDays > 1) ? "$countDays dias de foco" : "$countDays dia de foco";
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'App Revo',
        text:
            'Olha esse app, ele vai te ajudar a realizar seus sonhos, atráves de foco e metas.',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Revo  - Foco com metas');
  }

  exit(context) {
    FirebaseService().logout();
    FirebaseService().removeUserPref();
    push(context, LoginPage(), isReplace: true);
  }
}
