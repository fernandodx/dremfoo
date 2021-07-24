import 'package:dremfoo/app/modules/login/domain/usecases/login_usecase.dart';
import 'package:dremfoo/app/modules/login/infra/datasources/firebase_datasource.dart';

import 'package:dremfoo/app/modules/login/infra/repositories/login_repository.dart';
import 'package:dremfoo/app/modules/login/domain/stories/login_store.dart';
import 'package:dremfoo/app/modules/login/ui/pages/login_widget_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => FirebaseDataSource()),
    Bind.lazySingleton((i) => LoginRepository()),
    Bind.lazySingleton((i) => LoginUseCase(i.get<LoginRepository>())),
    Bind.lazySingleton((i) => LoginStore(i.get<LoginUseCase>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => LoginWidgetPage())
  ];
}
