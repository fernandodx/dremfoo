import 'package:dremfoo/app/modules/dreams/domain/stories/dreams_store.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/dream_usecase.dart';
import 'package:dremfoo/app/modules/dreams/ui/pages/dreams_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DreamsModule extends Module {
  @override
  final List<Bind> binds = [

    Bind.lazySingleton((i) => DreamUseCase()),
    Bind.lazySingleton((i) => DreamsStore(i.get<DreamUseCase>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => DreamsPage()),
  ];
}
