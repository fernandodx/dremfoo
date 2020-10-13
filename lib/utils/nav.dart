import 'package:dremfoo/utils/analytics_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> push(BuildContext context, Widget page, {bool isReplace = false}) async {
  if (isReplace) {
    final result = Navigator.pushReplacement(
        context, FadeRoute(builder: (context) => page));
    return result;
  }
  final result = await Navigator.push(context, FadeRoute(builder: (context) => page));
  AnalyticsUtil.setCurrentScreen(page.toString(), page.toString());
  return result;
}

void pop(BuildContext context, result) {
   Navigator.pop(context, result);
}

class FadeRoute<T> extends MaterialPageRoute<T> {
  FadeRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {

//    if (settings.isInitialRoute) {
//      return child;
//    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
