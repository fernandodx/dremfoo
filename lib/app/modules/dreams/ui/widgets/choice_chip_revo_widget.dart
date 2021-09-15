import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';

class ChoiceChipRevoWidget extends StatelessWidget {

  String label;
  String color;
  bool isCompleted;
  Function(bool)? onSelected;

  ChoiceChipRevoWidget(
  {required this.label, required this.color, required this.isCompleted, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: ChoiceChip(
        elevation: 8,
        label: TextUtil.textChipMenu(label),
        backgroundColor: Utils.colorFromHex(color),
        selectedColor: AppColors.colorPrimary,
        selected: false,
        avatar: isCompleted
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
        onSelected: onSelected,
      ),
    );
  }
}