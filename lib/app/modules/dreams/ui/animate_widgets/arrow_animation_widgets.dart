import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:flutter/material.dart';

class ArrowAnimationWidget extends AnimatedWidget {
  const ArrowAnimationWidget({required AnimationController controller})
      : super(listenable: controller);

  Animation<double> get _rotation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
        turns: _rotation.drive(Tween(begin: 0.0, end: 0.5)),
        child: Container(
            padding: EdgeInsets.all(8),
            child: Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.colorTextLight,
          size: 34,
        )));
  }
}
