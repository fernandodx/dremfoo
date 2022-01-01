import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';

class ButtonAppbarWidget extends StatelessWidget {

  final Function()? onTapButton;
  final String labelButton;
  ButtonAppbarWidget({this.onTapButton, required this.labelButton});

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: onTapButton,
        child: Chip(
          padding: EdgeInsets.only(left: 8, right: 8),
          label: TextUtil.textChip(labelButton,),
          backgroundColor: Theme.of(context).hintColor.withAlpha(180),
        ),
      ),
    );
  }
}
