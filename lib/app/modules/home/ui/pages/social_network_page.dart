import 'dart:ui';

import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/home/domain/stories/social_network_store.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/remoteconfig_util.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/widget/alert_bottom_sheet.dart';
import 'package:email_launcher/email_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialNetworkPage extends StatefulWidget {

  @override
  SocialNetworkPageState createState() => SocialNetworkPageState();
}
class SocialNetworkPageState extends ModularState<SocialNetworkPage, SocialNetworkStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextUtil.textAppbar("Mídias sociais"),
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(Utils.getPathAssetsImg("background_media.jpg"), width: double.infinity, height: double.infinity, fit: BoxFit.cover,),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black26),
          ),
          body(),
        ],
      ),
    );
  }

  Container body() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            elevation: 15,
            margin: EdgeInsets.all(36),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: <Widget>[
                Image.asset(Utils.getPathAssetsImg("background_media.jpg")),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    getAppSocialInstagram(),
                    SizedBox(
                      width: 20,
                    ),
                    getAppSocialYoutube(),
                    SizedBox(
                      width: 20,
                    ),
                    getAppSocialSite(),
                    SizedBox(
                      width: 20,
                    ),
                    getAppSocialContato(),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getAppSocialInstagram() {
    return Visibility(
      visible: RemoteConfigUtil().isEnableMediaInstagram(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
              onTap: () => launch("https://www.instagram.com/revometas/"),
              child: FaIcon(FontAwesomeIcons.instagram, size: 35,),
          ),
          TextUtil.textDefault("Instagram")
        ],
      ),
    );
  }

  Widget getAppSocialYoutube() {
    return Visibility(
      visible: RemoteConfigUtil().isEnableMediaYoutube(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () =>launch("https://www.youtube.com/channel/UC8auEL7B2jO0Uk1URQGvPGg"),
            child: FaIcon(FontAwesomeIcons.youtube, size: 35,),
          ),
          TextUtil.textDefault("Youtube")
        ],
      ),
    );
  }

  Widget getAppSocialSite() {
    return Visibility(
      visible: RemoteConfigUtil().isEnableMediaSite(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 9, top: 9),
            child: InkWell(
              onTap: () => launch(
                  "https://play.google.com/store/apps/dev?id=7876738907056259315"),
              child: FaIcon(
                FontAwesomeIcons.chrome, size: 35,
              ),
            ),
          ),
          TextUtil.textDefault("Site")
        ],
      ),
    );
  }

  void sendEmail() async {

    try{

      Email email = Email(
          to: ['fernandodx@hotmail.com'],
          // cc: ['nando.djx@gmail.com'],
          // bcc: ['fdias@outlook.com'],
          subject: 'REVO - Metas com foco',
          body: 'Olá Fernando, '
      );
      await EmailLauncher.launch(email);

    }catch(error){
      alertBottomSheet(context, msg: "Não foi possível enviar um e-mail, verique se você configurou o app de e-mail no celular.");
    }
  }

  Widget getAppSocialContato() {
    return Visibility(
      visible: RemoteConfigUtil().isEnableMediaContato(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 9, top: 9),
            child: InkWell(
              onTap: () {
                sendEmail();
              },
              child: FaIcon(
                FontAwesomeIcons.envelope, size: 35,
              ),
            ),
          ),
          TextUtil.textDefault("Contato")
        ],
      ),
    );
  }
}