import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/appbar_revo_widget.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/home/domain/stories/home_store.dart';
import 'package:dremfoo/app/modules/home/ui/widgets/chip_button_widget.dart';
import 'package:dremfoo/app/modules/home/ui/widgets/outline_button_with_image_widget.dart';
import 'package:dremfoo/app/modules/home/ui/widgets/video_youtube_widget.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/widget/alert_bottom_sheet.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:dremfoo/app/api/extensions/util_extensions.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, this.title = 'HomePage'}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ModularState<HomePage, HomeStore> {
  @override
  void initState() {
    super.initState();

    reaction<MessageAlert?>((_) => store.msgAlert, (msgErro) {
      if (msgErro != null) {
        alertBottomSheet(context, msg: msgErro.msg, title: msgErro.title, type: msgErro.type);
      }
    });

    store.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: AppbarRevoWidget(
            context: context,
            title: "Revo - Metas com foco",
            userRevo: store.currentUser).appBar,
        body: Container(
            margin: EdgeInsets.only(
              top: 16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ChipButtonWidget(
                        name: "Arquivo",
                        size: 80,
                        icon: FontAwesomeIcons.folderOpen,
                        onTap: () {
                          store.navigateArchivePage(context);
                        },
                      ),
                      ChipButtonWidget(
                        name: "Realizados",
                        size: 80,
                        icon: FontAwesomeIcons.clipboardCheck,
                        onTap: () {
                          store.navigateDreamsCompletedPage(context);
                        },
                      ),
                    ]),
                SpaceWidget(),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ChipButtonWidget(
                        name: "Notificações",
                        size: 80,
                        icon: FontAwesomeIcons.bell,
                        onTap: () {},
                      ),
                      ChipButtonWidget(
                        name: "Redes Sociais",
                        size: 80,
                        icon: FontAwesomeIcons.heart,
                        onTap: () {
                          store.navigateSocialNetworkPage(context);
                        },
                      ),
                    ]),
                SpaceWidget(),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: AppColors.colorDark,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40), topRight: Radius.circular(40))),
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Observer(builder: (context) {
                            return OutlineButtonWithImageWidget(
                                urlImage: store.currentUser?.focus?.level?.urlIcon,
                                title: "Nível",
                                subTitle: store.currentUser?.focus?.level?.name);
                          }),
                          Observer(builder: (context) {
                            return OutlineButtonWithImageWidget(
                                icon: FontAwesomeIcons.fire,
                                title: "Foco",
                                subTitle: "${store.currentUser?.focus?.countDaysFocus} dias");
                          }),
                        ],
                      ),
                      SpaceWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Observer(builder: (context) {
                            return OutlineButtonWithImageWidget(
                                icon: FontAwesomeIcons.trophy,
                                title: "Rank",
                                subTitle: store.postionRankFormat);
                          }),
                          Observer(builder: (context) {
                            return OutlineButtonWithImageWidget(
                                icon: FontAwesomeIcons.checkCircle,
                                title: "Último acesso",
                                subTitle: "${store.lastDateAcess?.format()}");
                          }),
                        ],
                      ),
                      SpaceWidget(),
                      SpaceWidget(),
                      Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.only(right: 8),
                          child: TextUtil.textTitulo("Conteúdo gratuito",
                              align: TextAlign.right, color: AppColors.colorTextLight)),
                      SpaceWidget(),
                      Observer(
                        builder: (context) {
                          return VideoYoutubeWidget(
                            video: store.video,
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            )),
      );
    });

  }
}
