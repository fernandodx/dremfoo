import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future push(BuildContext context, Widget page, {bool isReplace = false}) {
  if (isReplace) {
    return Navigator.pushReplacement(
        context, FadeRoute(builder: (context) => page));
  }
  return Navigator.push(context, FadeRoute(builder: (context) => page));
}

bool pop(BuildContext context, result) {
  return Navigator.pop(context, result);
}

class FadeRoute<T> extends MaterialPageRoute<T> {
  FadeRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {

    if (settings.isInitialRoute) {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
