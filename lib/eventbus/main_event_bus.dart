import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

enum TipoEvento {event1, event2}

class MainEventBus {

  final _eventBusController = StreamController<TipoEvento>.broadcast();

  final _eventBusUserController = StreamController<FirebaseUser>.broadcast();

  Stream<TipoEvento> get stream => _eventBusController.stream;
  Stream<FirebaseUser> get streamUser => _eventBusUserController.stream;

  MainEventBus get(context) => Provider.of<MainEventBus>(context, listen: false);

  void updateUser(FirebaseUser user) {
    _eventBusUserController.add(user);
  }

  void sendEvent(TipoEvento tipo){
    _eventBusController.add(tipo);
  }


  void dispose() {
    _eventBusController.close();
  }





}

