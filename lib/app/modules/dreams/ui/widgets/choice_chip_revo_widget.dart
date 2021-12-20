import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';

class ChoiceChipRevoWidget extends StatelessWidget {
  String label;
  String color;
  bool isCompleted;
  Function(bool) onSelected;

  ChoiceChipRevoWidget(
      {required this.label,
      required this.color,
      required this.isCompleted,
      required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: ChoiceChip(
          padding: EdgeInsets.only(left: 1, right: 8),
          elevation: 8,
          label: TextUtil.textChipLight(label, fontSize: 12),
          backgroundColor: Utils.colorFromHex(color),
          selectedColor: Theme.of(context).focusColor,
          selected: isCompleted,
          avatar: isCompleted
              ? CircleAvatar(
                  radius: 12,
                  backgroundColor: Theme.of(context).primaryColorDark,
                  child: Icon(
                    Icons.check,
                    color: AppColors.colorlight,
                    size: 14,
                  ),
                )
              : Icon(
                  Icons.radio_button_unchecked,
                  color: Theme.of(context).primaryColorDark,
                ),
          onSelected: (isSelected) => onSelected(isSelected)),
    );
  }
}
