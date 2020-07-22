import 'dart:ui';

import 'package:dremfoo/api/firebase_service.dart';
import 'package:dremfoo/eventbus/main_event_bus.dart';
import 'package:dremfoo/resources/app_colors.dart';
import 'package:dremfoo/ui/info_media_social_page.dart';
import 'package:dremfoo/ui/list_video_page.dart';
import 'package:dremfoo/ui/login_page.dart';
import 'package:dremfoo/utils/nav.dart';
import 'package:dremfoo/utils/text_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class AppDrawerMenu extends StatelessWidget {

  String urlImgBackgound;

  AppDrawerMenu({this.urlImgBackgound = "https://i0.wp.com/errejotanoticias.com.br/wp-content/uploads/2019/12/Divulgação-Foto-da-exposição-Canoa-Havaiana.jpeg?fit=880%2C660&ssl=1"});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: AppColors.backgroundDrawerDecoration(),
        child: ListView(
          children: <Widget>[
            StreamBuilder<FirebaseUser>(
                stream: MainEventBus().get(context).streamUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _userAccountHeader(snapshot.data);
                  }

                  return FutureBuilder(
                    future: FirebaseAuth.instance.currentUser(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return _userAccountHeader(snapshot.data);
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  );
                }),
            SizedBox(height: 16.0,),
            ListTile(
              leading: Icon(
                Icons.live_tv,
                color: Colors.white,
              ),
              title: TextUtil.textDefault("Conteúdo gratuito - REVO", color: Colors.white),
              subtitle: TextUtil.textDefault("Série de vídeos por trás do seu funcionamento, aprenda a dominar seus hábitos", color: Colors.white70),
              onTap: () => push(context, ListVideoPage()),
            ),
            ListTile(
              leading: Icon(
                Icons.people,
                color: Colors.white,
              ),
              title: TextUtil.textDefault("Redes Sociais", color: Colors.white),
              subtitle: TextUtil.textDefault("Siga nos nas nossos canais de comunicação", color: Colors.white70),
              onTap: () => push(context, InfoMediaSocialPage()),
            ),
            ListTile(
              leading: Icon(
                Icons.share,
                color: Colors.white,
              ),
              title: TextUtil.textDefault("Compartilhe", color: Colors.white),
              subtitle: TextUtil.textDefault("Compartilhe Revo com os seus amigos", color: Colors.white70),
              onTap: () => share(),
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              title: TextUtil.textDefault("Sair", color: Colors.white),
              onTap: () => exit(context),
            ),
          ],
        ),
      ),
    );
  }


  _userAccountHeader(FirebaseUser user) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(urlImgBackgound,
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
            backgroundImage: NetworkImage(user.photoUrl ??
                "https://cdn3.iconfinder.com/data/icons/avatars-15/64/_Bearded_Man-17-512.png"),
          ),
        ),
      ),
    );
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'App Revo',
        text: 'Olha esse app, ele vai te ajudar a realizar seus sonhos, atráves de foco e metas.',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Revo  - Foco com metas'
    );
  }

  exit(context) {

    FirebaseService().logout();
    FirebaseService().removeUserPref();
    push(context, LoginPage(), isReplace: true);

  }
}
