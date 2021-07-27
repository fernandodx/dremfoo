import 'dart:async';

import 'package:dremfoo/app/model/level_revo.dart';
import 'package:dremfoo/app/model/user_focus.dart';
import 'package:provider/provider.dart';

enum TipoAcao {DISABLE_NOTIFICATION_DAILY_WEEKLY,UPDATE_NOTIFICATION}

class UserEventBus {

  final _eventBusController = StreamController<TipoAcao>.broadcast();
  final _eventBusUpdateLevel = StreamController<UserFocus>.broadcast();

  Stream<TipoAcao> get stream => _eventBusController.stream;
  Stream<UserFocus> get streamLevel => _eventBusUpdateLevel.stream;

  UserEventBus get(context) => Provider.of<UserEventBus>(context, listen: false);

  void sendEvent(TipoAcao tipo){
    _eventBusController.add(tipo);
  }

  void updateLevel(UserFocus userFocus){
    _eventBusUpdateLevel.add(userFocus, );
  }

  void dispose() {
    _eventBusController.close();
    _eventBusUpdateLevel.close();
  }





}

