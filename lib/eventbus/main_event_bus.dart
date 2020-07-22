import 'dart:async';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

enum TipoEvento {event1, event2}

class MainEventBus {

  final _eventBusController = StreamController<TipoEvento>.broadcast();

  final _eventBusUserController = StreamController<FirebaseUser>.broadcast();

  final _eventBusRegisterDreamController = StreamController<bool>.broadcast();

  Stream<TipoEvento> get stream => _eventBusController.stream;
  Stream<FirebaseUser> get streamUser => _eventBusUserController.stream;
  Stream<bool> get streamRegisterDream => _eventBusRegisterDreamController.stream;

  MainEventBus get(context) => Provider.of<MainEventBus>(context, listen: false);

  void updateUser(FirebaseUser user) {
    _eventBusUserController.add(user);
  }

  void sendEvent(TipoEvento tipo){
    _eventBusController.add(tipo);
  }

  void sendEventUpdateRegisterApp(bool isFetch){
    _eventBusRegisterDreamController.add(isFetch);
  }

  void dispose() {
    _eventBusController.close();
  }





}

