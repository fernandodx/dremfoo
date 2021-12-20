import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';

class ButtonOutlinedRevoWidget extends StatelessWidget {

  final IconData icon;
  final String label;
  final Function()? onTap;

  ButtonOutlinedRevoWidget({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()),
          side: MaterialStateProperty.resolveWith<BorderSide>(
              (Set<MaterialState> states) {
            final Color color = states.contains(MaterialState.pressed)
                ? AppColors.colorAcent
                : AppColors.colorGreenLight;
            return BorderSide(color: color, width: 2);
          }),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppColors.colorSubText,
              size: 20,
            ),
            SpaceWidget(
              isSpaceRow: true,
            ),
            TextUtil.textSubTitle(label, fontSize: 14)
          ],
        ));
  }
}
