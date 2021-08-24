import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:flutter/material.dart';

class BackgroundFormWidget extends StatelessWidget {
  final Widget child;
  const BackgroundFormWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            gradient: AppColors.backgroundPageGradient()),
        child: child,
    );

  }
}