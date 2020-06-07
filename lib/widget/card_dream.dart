import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/resources/app_colors.dart';
import 'package:dremfoo/utils/text_util.dart';
import 'package:dremfoo/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardDream extends StatelessWidget {
  String urlImg;
  String imgBase64;
  String imageAsset;
  Function onTap;
  String title;
  String subTitle;
  bool selected;
  bool isCardAdd;

  CardDream(
      {this.urlImg,
      this.imgBase64,
      this.imageAsset,
      this.isCardAdd = false,
      this.subTitle,
      @required this.onTap,
      @required this.title,
      @required this.selected});

  @override
  Widget build(BuildContext context) {
    if (isCardAdd) {
      return _creatCardAdd();
    } else {
      return _creatCardDream();
    }
  }

  Widget _creatCardDream() {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: _getImg(),
              ),
              margin: EdgeInsets.all(4),
            ),
            Container(
              constraints: BoxConstraints.expand(width: 160, height: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.settings,
                      color: AppColors.colorDark,
                    ),
                    margin: EdgeInsets.all(4),
                  ),
                  Container(
                    padding: EdgeInsets.all(4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextUtil.textDefault(
                          title,
                          fontSize: 12,
                        ),
                        TextUtil.textDefault(
                          subTitle,
                          fontSize: 10,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
              child: TextUtil.textTitulo(title, align: TextAlign.center),
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
    double width = isCardAdd ? 90 : 160;
    double height = isCardAdd ? 90 : 110;

    if (urlImg != null) {
      return CachedNetworkImage(
          fit: fit, width: width, height: height, imageUrl: urlImg);
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
