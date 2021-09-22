import 'package:dremfoo/app/modules/core/core_module.dart';
import 'package:dremfoo/app/modules/dreams/dreams_module.dart';
import 'package:dremfoo/app/modules/dreams/ui/pages/dreams_page.dart';
import 'package:dremfoo/app/modules/home/domain/stories/bottom_navigate_store.dart';
import 'package:dremfoo/app/modules/home/domain/stories/home_store.dart';
import 'package:dremfoo/app/modules/home/ui/pages/bottom_navigate_page.dart';
import 'package:dremfoo/app/modules/home/ui/pages/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../app_module.dart';

class HomeModule extends Module {

  @override
  final List<Module> imports = [
    CoreModule(),
    DreamsModule()
  ];

  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => BottomNavigateStore()),
    Bind.lazySingleton((i) => HomeStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute("/home", child: (_, args) => BottomNavigatePage(),
      children: [
        ChildRoute("/dashboard", child: (_, arg) => HomePage()),
        // ChildRoute("/dream", child: (_, arg) => DreamsPage()),
        ModuleRoute("/dream", module: DreamsModule()),
        ChildRoute("/chart", child: (_, arg) => DreamsPage()),
        ChildRoute("/challenge", child: (_, arg) => DreamsPage()),
      ]),
  ];
}
