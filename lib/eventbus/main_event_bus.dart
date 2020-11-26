import 'dart:async';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

enum TipoEvento {FETCH,REFRESH, FETCH_WITH_LOADING}

class MainEventBus {

  final _eventBusController = StreamController<TipoEvento>.broadcast();

  final _eventBusUserController = StreamController<User>.broadcast();

  final _eventBusRegisterDreamController = StreamController<TipoEvento>.broadcast();

  final _eventBusHomeDreamController = StreamController<TipoEvento>.broadcast();

  Stream<TipoEvento> get stream => _eventBusController.stream;
  Stream<User> get streamUser => _eventBusUserController.stream;
  Stream<TipoEvento> get streamRegisterDream => _eventBusRegisterDreamController.stream;
  Stream<TipoEvento> get streamHomeDream => _eventBusHomeDreamController.stream;

  MainEventBus get(context) => Provider.of<MainEventBus>(context, listen: false);

  void updateUser(User user) {
    _eventBusUserController.add(user);
  }

  void sendEvent(TipoEvento tipo){
    _eventBusController.add(tipo);
  }

  void sendEventHomeDream(TipoEvento tipo){
    _eventBusHomeDreamController.add(tipo);
  }

  void sendEventRegisterDreamApp(TipoEvento tipo){
    _eventBusRegisterDreamController.add(tipo);
  }

  void dispose() {
    _eventBusController.close();
  }





}

