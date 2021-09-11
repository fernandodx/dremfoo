import 'package:flutter/material.dart';

import 'image_positioned_left_widget.dart';
import 'info_percent_dream_widget.dart';

class HeaderItemDreamWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Stack(
        children: [
          ImagePositionedLeftWidget(
              urlImage: "https://www.criandocomapego.com/wp-content/uploads/2018/03/manual-dos-sonhos.jpg",
              leftPercent: 0.8,
              height: 180),
          InfoPercentDreamWidget(),
        ],
      ),
      width: double.maxFinite,
      height: 180,
    );
  }
}
