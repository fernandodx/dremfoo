import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/dreams_store.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

class DreamsPage extends StatefulWidget {
  final String title;
  const DreamsPage({Key? key, this.title = 'DreamsPage'}) : super(key: key);
  @override
  DreamsPageState createState() => DreamsPageState();
}
class DreamsPageState extends ModularState<DreamsPage, DreamsStore> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(imageUrl: "https://www.criandocomapego.com/wp-content/uploads/2018/03/manual-dos-sonhos.jpg",),
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
                    Icon(Icons.keyboard_arrow_up, color: AppColors.colorTextLight, size: 34,)
                  ],
                ),
                SpaceWidget(),
                SpaceWidget(),
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
                )


              ],
            ),
          )



        ],
      ),
    );
  }
}