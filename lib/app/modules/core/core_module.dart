import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/core/domain/utils/revo_analytics.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CoreModule extends Module {

  @override
  final List<Bind> binds = [
    Bind.instance<String>("KEY", export: true),
    Bind.instance<RevoAnalytics>(RevoAnalytics(), export: true),
    Bind.instance<UserRevo>(UserRevo(), export: true)
  ];

  @override
  final List<ModularRoute> routes = [];

}