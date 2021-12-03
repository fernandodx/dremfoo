import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChipButtonWidget extends StatelessWidget {
  late String name;
  late IconData icon;
  late Function()? onTap;
  late double size;

  ChipButtonWidget({
    required this.name,
    required this.icon,
    this.size = 70,
    this.onTap});

  @override
  Widget build(BuildContext context) {
   return InkWell(
     onTap: onTap,
     borderRadius: BorderRadius.all(Radius.circular(22)),
     child: Chip(
       onDeleted: onTap,
       deleteIcon: Icon(Icons.navigate_next,  color: AppColors.colorTextChipMenu,),
       labelPadding: EdgeInsets.only(top: 12, bottom: 12, left: 4, right: 0),
       label:  Container(
           width: size,
           child: TextUtil.textChipMenu(name, maxLines: 1)),
       avatar: CircleAvatar(
         backgroundColor: AppColors.colorButtonChipDark,
         child: FaIcon(
           icon,
           color: Colors.white70,
           size: 15,
         ),
       ),
     ),
   );
  }
}