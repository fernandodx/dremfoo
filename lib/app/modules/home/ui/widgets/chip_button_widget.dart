import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';

class ChipButtonWidget extends StatelessWidget {
  late String name;
  late Function()? onTap;

  ChipButtonWidget({required this.name, this.onTap});

  @override
  Widget build(BuildContext context) {
   return InkWell(
     onTap: onTap,
     borderRadius: BorderRadius.all(Radius.circular(22)),
     child: Chip(
       onDeleted: onTap,
       deleteIcon: Icon(Icons.navigate_next,  color: AppColors.colorTextChipMenu,),
       backgroundColor: AppColors.colorButtonChip,
       labelPadding: EdgeInsets.only(top: 12, bottom: 12, left: 8, right: 8),
       label:  Container(
           width: 70,
           child: TextUtil.textChipMenu(name, maxLines: 1)),
       avatar: CircleAvatar(
         backgroundColor: AppColors.colorButtonChipDark,
         child: Icon(
           Icons.date_range,
           color: Colors.white70,
           size: 15,
         ),
       ),
     ),
   );
  }
}