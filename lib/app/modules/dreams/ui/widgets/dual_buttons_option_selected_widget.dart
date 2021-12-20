import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:flutter/material.dart';

class DualButtonsOptionSelectedWidget extends StatelessWidget {
  final String titleLeft;
  final String titleRight;
  final bool isLeftSelect;
  final Function()? onPressLeft;
  final Function()? onPressRight;


  DualButtonsOptionSelectedWidget({
      required this.titleLeft,
      required this.titleRight,
      required this.isLeftSelect,
      this.onPressLeft,
      this.onPressRight});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: (MediaQuery.of(context).size.width/2) -24,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30)
                    ),
                  ),
                  primary: isLeftSelect ? Theme.of(context).hintColor :Theme.of(context).primaryColorDark,
                  onPrimary: isLeftSelect ? Theme.of(context).primaryColorDark : Theme.of(context).hintColor
              ),
              onPressed: onPressLeft,
              child: Text(titleLeft, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),)
          ),
        ),
        SizedBox(width: 8),
        Container (
          width: (MediaQuery.of(context).size.width/2) -24,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30)
                  ),
                ),
                primary: !isLeftSelect ? Theme.of(context).hintColor : Theme.of(context).primaryColorDark,
                onPrimary: !isLeftSelect ? Theme.of(context).primaryColorDark : Theme.of(context).hintColor
            ),
            onPressed: onPressRight,
            child: Text(titleRight),
          ),
        )
      ],
    );
  }
}