import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/home/domain/stories/home_store.dart';
import 'package:dremfoo/app/modules/home/ui/widgets/chip_button_widget.dart';
import 'package:dremfoo/app/modules/home/ui/widgets/outline_button_with_image_widget.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, this.title = 'HomePage'}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ModularState<HomePage, HomeStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
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
                      onTap: () {},
                    ),
                    ChipButtonWidget(
                      name: "Realizados",
                      onTap: () {},
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
                      onTap: () {},
                    ),
                    ChipButtonWidget(
                      name: "Redes Sociais",
                      onTap: () {},
                    ),
                  ]),
              SpaceWidget(),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                color: AppColors.colorDark,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))),
                width: double.maxFinite,
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlineButtonWithImageWidget(
                        urlImage: "https://png.pngtree.com/element_pic/25/04/20/16571d74efb815e.jpg",
                        title: "Nível",
                        subTitle: "Egg"),
                    OutlineButtonWithImageWidget(
                        urlImage: "https://png.pngtree.com/element_pic/25/04/20/16571d74efb815e.jpg",
                        title: "Foco",
                        subTitle: "10 dias")
                  ],
                ),
                SpaceWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlineButtonWithImageWidget(
                        urlImage: "https://png.pngtree.com/element_pic/25/04/20/16571d74efb815e.jpg",
                        title: "Rank",
                        subTitle: "Posição: 32˚"),
                    OutlineButtonWithImageWidget(
                        urlImage: "https://png.pngtree.com/element_pic/25/04/20/16571d74efb815e.jpg",
                        title: "Metas diárias",
                        subTitle: "6 metas")
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
                Container(
                  padding: EdgeInsets.all(6),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            child: CachedNetworkImage(
                              imageUrl: "https://img.youtube.com/vi/OxWV4uVQ4BU/hqdefault.jpg",
                              fit: BoxFit.cover,
                              height: 130,
                              width: double.maxFinite,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          Align(
                            child: Icon(
                              Icons.play_circle_outline,
                              color: Colors.white70,
                              size: 80,
                            ),
                          )
                        ],
                        alignment: Alignment.center,
                      ),
                      TextUtil.textSubTitle(
                          "Técnica para realizar sonhos | Como criar um mural dos sonhos com app REVO | 10:16",
                          color: AppColors.colorTextLight)
                    ],
                  ),
                ),
              ],
                ),
              )
            ],
          )),
    );
  }
}
