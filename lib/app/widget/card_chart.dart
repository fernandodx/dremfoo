import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/model/chart_goals.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';

class CardChart extends StatelessWidget {
  Function onTap;
  String title;
  Widget chart;

  CardChart(
      {@required this.onTap,
      @required this.title,
      @required this.chart});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => print("EDITAR"),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextUtil.textTitulo(title),
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: SizedBox(
                  height: 150,
                  width: 200, //Colocar o tamnho da tela
                  child: chart,
                )
              ),
              margin: EdgeInsets.all(4),
            ),
          ],
        ),
      ),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    );
  }
}
