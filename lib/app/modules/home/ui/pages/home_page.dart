
import 'package:dremfoo/app/api/extensions/util_extensions.dart';
import 'package:dremfoo/app/modules/core/config/app_purchase.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/alert_bottom_sheet.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/appbar_revo_widget.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/loading_widget.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/home/domain/stories/home_store.dart';
import 'package:dremfoo/app/modules/home/ui/widgets/chip_button_widget.dart';
import 'package:dremfoo/app/modules/home/ui/widgets/outline_button_with_image_widget.dart';
import 'package:dremfoo/app/modules/home/ui/widgets/video_youtube_widget.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/remoteconfig_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobx/mobx.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, this.title = 'HomePage'}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ModularState<HomePage, HomeStore> {

  AppPurchase _appPurchase = Modular.get<AppPurchase>();

  @override
  void initState() {
    super.initState();

    reaction<MessageAlert?>((_) => store.msgAlert, (msgErro) {
      if (msgErro != null) {
        alertBottomSheet(context,
            msg: msgErro.msg,
            title: msgErro.title,
            type: msgErro.type
        );
      }
    });

    reaction<bool>((_) => _appPurchase.isError, (isErro) {
      if (isErro) {
        alertBottomSheet(context,
            msg: "Tivemos um erro na compra da sua assinatura, verifique a google play.",
            title: "Erro na assinatura do Revo",
            type: TypeAlert.ERROR
        );
      }
    });

    reaction<bool>((_) => _appPurchase.isPending, (isPending) {
      if (isPending) {
        alertBottomSheet(context,
            msg: "O pgamento da sua assinatura esta pendente, verifique a google play.",
            title: "Pagamento pendente na assinatura do Revo",
            type: TypeAlert.ERROR
        );
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
                title: Translate.i().get.label_title_app,
                userRevo: store.currentUser)
            .appBar,
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
                        name: Translate.i().get.label_archive,
                        size: 80,
                        icon: FontAwesomeIcons.folderOpen,
                        onTap: () {
                          store.navigateArchivePage(context);
                        },
                      ),
                      ChipButtonWidget(
                        name: Translate.i().get.label_perfomed,
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
                        name: Translate.i().get.label_free_content,
                        size: 80,
                        icon: FontAwesomeIcons.video,
                        onTap: () {
                          store.navigatePageFreeVideos(context);
                        },
                      ),
                      ChipButtonWidget(
                        name: Translate.i().get.label_social_network,
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
                      color: Theme.of(context).backgroundColor.withAlpha(180),
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
                                title: Translate.i().get.label_level,
                                subTitle: store.currentUser?.focus?.level?.name);
                          }),
                          Observer(builder: (context) {
                            return OutlineButtonWithImageWidget(
                                icon: FontAwesomeIcons.fire,
                                title: Translate.i().get.label_focus,
                                subTitle:
                                    "${store.currentUser?.focus?.countDaysFocus} ${Translate.i().get.label_days}");
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
                                title: Translate.i().get.label_rank,
                                subTitle: store.postionRankFormat);
                          }),
                          Observer(builder: (context) {
                            return OutlineButtonWithImageWidget(
                                icon: FontAwesomeIcons.checkCircle,
                                title: Translate.i().get.last_acess,
                                subTitle: store.lastDateAcess != null ? "${store.lastDateAcess?.format()}" : "");
                          }),
                        ],
                      ),
                      SpaceWidget(),
                      Observer(
                        builder: (context) {
                          return VideoYoutubeWidget(
                            video: store.video,
                          );
                        },
                      ),
                      SpaceWidget(),
                      Observer(builder: (context) {

                        Widget ad = LoadingWidget("");

                        // if(store.bannerAd != null && _appPurchase.isShowAd) {
                        if(store.bannerAd != null){
                          ad =  AdWidget(ad: store.bannerAd!,);
                        }

                        return Visibility(
                            // visible: AppPurchase.getInstance().isShowAd && RemoteConfigUtil().isEnableAd() && store.isBannerAdReady,
                            visible: store.isBannerAdReady && _appPurchase.isShowAd,
                            child: Container(
                              alignment: Alignment.center,
                              width: double.maxFinite,
                              height: store.bannerAd?.size.height.toDouble(),
                              child: ad,
                            ));
                      })
                    ],
                  ),
                )
              ],
            )),
      );
    });
  }

  @override
  void dispose() {
    store.bannerAd?.dispose();
    super.dispose();
  }
}
