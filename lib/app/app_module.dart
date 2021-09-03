import 'package:dremfoo/app/modules/home/home_module.dart';
import 'package:dremfoo/app/modules/login/login_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    // ModuleRoute(Modular.initialRoute, module: LoginModule()),
    // ModuleRoute(MODULE_HOME, module: HomeModule()),

    ModuleRoute(Modular.initialRoute, module: HomeModule()),
  ];

  static final String MODULE_HOME = "/home";

}