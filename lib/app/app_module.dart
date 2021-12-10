import 'package:dremfoo/app//app_controller.dart';
import 'package:dremfoo/app/app_widget.dart';
import 'package:dremfoo/app/modules/dreams/dreams_module.dart';
import 'package:dremfoo/app/modules/home/home_module.dart';
import 'package:dremfoo/app/modules/login/login_module.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
    // ModuleRoute(MODULE_HOME, module: HomeModule()),
    // ModuleRoute(MODULE_DREAM, module: DreamsModule()),

    // ModuleRoute(Modular.initialRoute, module: HomeModule()),
    // ModuleRoute(MODULE_DREAM, module: DreamsModule()),
  ];


  static final String MODULE_HOME = "/home";
  static final String MODULE_DREAM = "/dream";
}
