import 'package:flutter/material.dart';

class LineWidget extends StatelessWidget {
  Color color;
  double maxHeight;
  double minWidth;

  LineWidget({this.color = Colors.white, this.maxHeight = 2, this.minWidth = 300});

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: Container(
        constraints: BoxConstraints(
          minWidth: minWidth,
          maxHeight: maxHeight,
        ),
        color: color,
      ),
    );
  }
}