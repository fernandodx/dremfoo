import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/api/firebase_service.dart';
import 'package:dremfoo/bloc/base_bloc.dart';
import 'package:dremfoo/eventbus/user_event_bus.dart';
import 'package:dremfoo/model/user.dart';
import 'package:dremfoo/utils/prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ConfigNotificationBloc extends BaseBloc {

  bool isEnableNotification;
  String descInitHourNotification;
  String descFinishHourNotification;
  Timestamp initHourNotification;
  Timestamp finishHourNotification;


  void updateConfigNotification(context){
    Prefs.putBool("USER_PREF_ISNOTIFICATION", isEnableNotification);
    Prefs.putInt("USER_PREF_INIT_NOTIFICATION", initHourNotification.toDate().millisecondsSinceEpoch);
    Prefs.putInt("USER_PREF_FINISH_NOTIFICATION", finishHourNotification.toDate().millisecondsSinceEpoch);
    FirebaseService().updateConfigUser(isEnableNotification, initHourNotification, finishHourNotification);

    if(isEnableNotification){
      UserEventBus().get(context).sendEvent(TipoAcao.UPDATE_NOTIFICATION);
    }else{
      UserEventBus().get(context).sendEvent(TipoAcao.DISABLE_NOTIFICATION_DAILY_WEEKLY);
    }
  }

  String _toNumberTimeFmt(int number){
    if(number<= 9){
      return "0$number";
    }
    return "$number";
  }

  String formatTimeStr(DateTime dateTime){
    return "${_toNumberTimeFmt(dateTime.hour)}:${_toNumberTimeFmt(dateTime.minute)}h";
  }





}