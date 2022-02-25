import 'package:flutter/material.dart';

class SpaceWidget extends StatelessWidget {

  bool isSpaceRow;

  SpaceWidget({this.isSpaceRow = false});

  @override
  Widget build(BuildContext context) {
    if(isSpaceRow){
      return SizedBox(width: 12);
    }
    return SizedBox(height: 12);
  }
}