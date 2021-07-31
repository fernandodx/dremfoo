import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/api/firebase_service.dart';
import 'package:dremfoo/app/api/bloc/config_notification_bloc.dart';
import 'package:dremfoo/app/api/eventbus/user_event_bus.dart';
import 'package:dremfoo/app/model/user.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/widget/app_drawer_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfigNotificationPage extends StatefulWidget {
  @override
  _ConfigNotificationPageState createState() => _ConfigNotificationPageState();
}

class _ConfigNotificationPageState extends State<ConfigNotificationPage> {
  final _bloc = ConfigNotificationBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: AppDrawerMenu(),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: TextUtil.textAppbar("Configurações das notificações"),
              )
            ];
          },
          body: SingleChildScrollView(
            child: FutureBuilder(
              future: FirebaseService().getPrefsUser(),
              builder: (BuildContext context, AsyncSnapshot<UserRevo?> snapshot) {
                if (snapshot.hasData) {
                  UserRevo user = snapshot.data!;
                  _bloc.isEnableNotification = user.isEnableNotification;
                  _bloc.initHourNotification = user.initNotification;
                  _bloc.finishHourNotification = user.finishNotification;
                  _bloc.descInitHourNotification = _bloc.formatTimeStr(user.initNotification?.toDate() ?? new DateTime.now());
                  _bloc.descFinishHourNotification = _bloc.formatTimeStr(user.finishNotification?.toDate() ?? new DateTime.now());

                  return bodyOptionsNotification(context);
                }

                return _bloc.getSimpleLoadingWidget();
              },
            ),
          )),
    );
  }

  Container bodyOptionsNotification(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Card(
            elevation: 8,
            margin: EdgeInsets.only(top: 12),
            child: SwitchListTile(
                title: TextUtil.textDefault("Habilitar notificações"),
                value: _bloc.isEnableNotification!,
                secondary: Icon(
                  Icons.notifications,
                  color: AppColors.colorPrimaryDark,
                ),
                onChanged: (value) => _updateOptionNotification(value)),
          ),
          InkWell(
            onTap: () => _updateInitNotificationTime(context),
            child: Card(
              elevation: 8,
              margin: EdgeInsets.only(top: 12),
              child: ListTile(
                title: TextUtil.textDefault("Hora para iniciar o dia"),
                leading: Icon(
                  Icons.access_time,
                  color: AppColors.colorPrimaryDark,
                ),
                trailing: TextUtil.textAccent(_bloc.descInitHourNotification),
              ),
            ),
          ),
          InkWell(
            onTap: () => _updateFinishNotificationTime(context),
            child: Card(
              elevation: 8,
              margin: EdgeInsets.only(top: 12),
              child: ListTile(
                title:
                    TextUtil.textDefault("Hora para visualizar os resultados"),
                leading: Icon(
                  Icons.access_time,
                  color: AppColors.colorPrimaryDark,
                ),
                trailing: TextUtil.textAccent(_bloc.descFinishHourNotification),
              ),
            ),
          )
        ],
      ),
    );
  }

  _updateOptionNotification(bool isEnableNotification){
    setState(() {
      _bloc.isEnableNotification = isEnableNotification;
      _bloc.updateConfigNotification(context);
    });
  }

  Future _updateInitNotificationTime(BuildContext context) async {
    try{
      TimeOfDay? time = await _showTimePicker24h(context);
      setState(() {
        DateTime now = DateTime.now();
        DateTime dateTime = DateTime(now.year, now.month, now.day,time!.hour, time.minute);

        _bloc.descInitHourNotification = _bloc.formatTimeStr(dateTime);
        _bloc.initHourNotification = Timestamp.fromDate(dateTime);

        _bloc.updateConfigNotification(context);
      });
    }catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

  }

  Future _updateFinishNotificationTime(BuildContext context) async {
    try{
      TimeOfDay? time = await _showTimePicker24h(context);
      setState(() {
        DateTime now = DateTime.now();
        DateTime dateTime = DateTime(now.year, now.month, now.day,time!.hour, time.minute);
        _bloc.descFinishHourNotification = _bloc.formatTimeStr(dateTime);
        _bloc.finishHourNotification = Timestamp.fromDate(dateTime);

        _bloc.updateConfigNotification(context);
      });
    }catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

  }

  Future<TimeOfDay?> _showTimePicker24h(BuildContext context) async {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
  }
}
