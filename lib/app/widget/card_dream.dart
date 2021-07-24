import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/model/color_dream.dart';
import 'package:dremfoo/app/model/dream.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CardDream extends StatelessWidget {
  String urlImg;
  String imgBase64;
  String imageAsset;
  Function onTap;
  String title;
  String subTitle;
  bool selected;
  bool isCardAdd;
  bool isDreamWait;
  ColorDream color;

  CardDream(
      {this.urlImg,
      this.imgBase64,
      this.imageAsset,
      this.isCardAdd = false,
      this.subTitle,
      this.isDreamWait,
      @required this.color,
      @required this.onTap,
      @required this.title,
      @required this.selected});

  @override
  Widget build(BuildContext context) {
    if (isCardAdd) {
      return _creatCardAdd();
    } else {
      return _creatCardDream(context);
    }
  }

  Widget _creatCardDream(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Stack(
         children: [
           Column(
             mainAxisSize: MainAxisSize.min,
             children: <Widget>[
               Container(
                 child: ClipRRect(
                   borderRadius: BorderRadius.all(Radius.circular(10,),),
                   child: _getImg(),
                 ),
                 margin: EdgeInsets.all(4),
               ),
               Container(
                 constraints: BoxConstraints.expand(width: 160, height: 40),
                 child: Container(
                   margin: EdgeInsets.all(2),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                       TextUtil.textDefault(title, fontSize: 13, maxLines: 1),
                       TextUtil.textDefault(subTitle, fontSize: 10, maxLines: 1),
                     ],
                   ),
                 ),
               ),
             ],
           ),
           Container(
              margin: EdgeInsets.only(bottom: 55, left: 12),
              width: 145,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: CircleAvatar(
                  maxRadius: 12,
                  backgroundColor: Utils.colorFromHex(color.secondary),
                  child: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isDreamWait != null ? isDreamWait : false,
              child: Container(
                width: 145,
                margin: EdgeInsets.all(12),
                child: Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    maxRadius: 12,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.hourglass_empty,
                      color: AppColors.colorDark,
                      size: 15,
                    ),
                  ),
                ),
              ),
            )

         ],
        ),
      ),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    );
  }

  Widget _creatCardAdd() {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: _getImg(),
              ),
              margin: EdgeInsets.all(4),
            ),
            Container(
              constraints: BoxConstraints.expand(width: 180, height: 40),
              child: TextUtil.textTitulo(
                title,
                align: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    );
  }

  Widget _getImg() {
    BoxFit fit = isCardAdd ? BoxFit.contain : BoxFit.cover;
    double width = isCardAdd ? 75 : 160;
    double height = isCardAdd ? 75 : 110;

    if (urlImg != null) {
      return CachedNetworkImage(
        fit: fit,
        width: width,
        height: height,
        imageUrl: urlImg,
      );
    }
    if (imgBase64 != null) {
      return Utils.string64ToImage(
        imgBase64,
        fit: fit,
        width: width,
        height: height,
      );
    }
    if (imageAsset != null) {
      return Image.asset(
        imageAsset,
        width: width,
        height: height,
        fit: fit,
      );
    }
    return Container(
      child: TextUtil.textDefault("Erro ao carregar a imagem"),
    );
  }
}
