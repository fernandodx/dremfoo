import 'package:dremfoo/app/modules/core/config/app_purchase.dart';
import 'package:dremfoo/app/modules/home/home_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AppPurchase(), export: true),
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
