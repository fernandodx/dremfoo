import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/dreams_store.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/cicular_progress_revo_widget.dart';
import 'package:dremfoo/app/modules/home/ui/widgets/chip_button_widget.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:percent_indicator/circular_percent_indicator.dart';

class DreamsPage extends StatefulWidget {
  final String title;
  const DreamsPage({Key? key, this.title = 'DreamsPage'}) : super(key: key);
  @override
  DreamsPageState createState() => DreamsPageState();
}
class DreamsPageState extends ModularState<DreamsPage, DreamsStore>  with SingleTickerProviderStateMixin {

  late final AnimationController _controllerPhotoAnim = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, -1.5),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  late final Animation<double> _animation = Tween(
    begin: 1.0,
    end: 0.0
  ).animate(_controller);


  late final Animation<double> _animationRotation = Tween(
      begin: 0.0,
      end: 0.5
  ).animate(_controller);

  bool isVisible = true;

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {

    MediaQueryData deviceInfo = MediaQuery.of(context);

    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: "https://www.criandocomapego.com/wp-content/uploads/2018/03/manual-dos-sonhos.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                        width: deviceInfo.size.width*0.8, //usar midia query
                        height: 180,
                        duration: Duration(seconds: 2),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 16),
                        width: double.maxFinite,
                        alignment: Alignment.topRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpaceWidget(),
                            CicularProgressRevoWidget(
                                titleCenter: "30%",
                                titleBottom: "Etapas",
                                value: 0.3),
                            SpaceWidget(),
                            CicularProgressRevoWidget(
                                titleCenter: "70%",
                                titleBottom: "Hoje",
                                value: 0.7),
                          ],
                        ),
                      )
                    ],
                  ),
                  width: double.maxFinite,
                  height: 180,
                ),
                SpaceWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextUtil.textSubTitle("Meu sonho", fontSize: 14, fontWeight: FontWeight.bold),
                          TextUtil.textDefault("Descrição do Sonho  - dhajh alkshdlasd lkjkljsd lkajsdkl alsdjlajsd alskdjalksjda sdasdjl  ",),
                        ],
                      ),
                    ),
                    InkWell(
                        onTap: (){
                          setState(() {
                            if(isVisible){
                              isVisible = false;
                              _controller.forward();
                            }else{
                              isVisible = true;
                              _controller.reverse();
                            }
                          });
                        },
                        child: RotationTransition(
                           turns: _animationRotation,
                            child: Icon(Icons.keyboard_arrow_up, color: AppColors.colorTextLight, size: 34,)
                        )
                    )
                  ],
                ),
                SpaceWidget(),
                SpaceWidget(),
                buildCrossFadeTransition(),
                TextUtil.textTitulo("Tenho que ficar junto, Bora lá !!!!"),
                TextUtil.textTitulo("Tenho que ficar junto, Bora lá !!!!"),
              ],
            ),
          )



        ],
      ),
    );
  }

  AnimatedCrossFade buildCrossFadeTransition() {
    return AnimatedCrossFade(
      crossFadeState: isVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: Duration(milliseconds: 500),
      firstChild: Container(
        width: double.maxFinite,
        height: 0,
      ),
      secondChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextUtil.textTitulo("Etapas"),
              SpaceWidget(isSpaceRow: true,),
              InkWell(child: Icon(Icons.visibility, color: AppColors.colorlight,), onTap: (){},)
            ],
          ),
          SpaceWidget(),
          Wrap(
            children: [
              Container(
                margin: EdgeInsets.only(right: 8),
                child: Chip(
                  avatar: CircleAvatar(
                    backgroundColor: AppColors.colorChipSecundary,
                    child: TextUtil.textChipLight("1˚",),
                  ),
                  label: TextUtil.textChip("Correr 10k e fazer atividade física"),
                  backgroundColor: AppColors.colorChipPrimary,
                ),
              ),

            ],
          ),
          SpaceWidget(),
          SpaceWidget(),
          TextUtil.textTitulo("Metas diárias"),
          SpaceWidget(),
          Wrap(
            children: [
              ChoiceChip(
                elevation: 8,
                label: TextUtil.textChipMenu("label"),
                backgroundColor: Utils.colorFromHex("#BAF3BE"),
                selectedColor: AppColors.colorPrimary,
                selected: false,
                avatar: false
                    ? CircleAvatar(
                  backgroundColor: AppColors.colorPrimaryDark,
                  child: Icon(
                    Icons.check,
                    color: AppColors.colorlight,
                    size: 18,
                  ),
                )
                    : Icon(
                  Icons.radio_button_unchecked,
                  color: AppColors.colorDark,
                ),
                onSelected: (selected) {
                  print("Selected");
                },
              )
            ],
          ),
          SpaceWidget(),
          Container(
            child: ChipButtonWidget(name: "Historico", onTap: () {},),
            width: double.maxFinite,
            alignment: Alignment.topRight,
          ),
        ],
      ),
    );
  }
}