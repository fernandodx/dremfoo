import 'dart:ui';

import 'package:dremfoo/bloc/home_page_bloc.dart';
import 'package:dremfoo/model/dream.dart';
import 'package:dremfoo/ui/register_dreams_page.dart';
import 'package:dremfoo/utils/nav.dart';
import 'package:dremfoo/utils/text_util.dart';
import 'package:dremfoo/utils/utils.dart';
import 'package:dremfoo/widget/app_button_default.dart';
import 'package:dremfoo/widget/app_drawer_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _bloc = HomePageBloc();

  @override
  void initState() {
    super.initState();

    _bloc.fetch(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: AppDrawerMenu(),
      body: StreamBuilder<List<Dream>>(
        stream: _bloc.streamDream,
        builder: (context, snapshots) {
          if (snapshots.hasError) {
            return Container(
              child: TextUtil.textDefault(snapshots.error.toString()),
            );
          }

          if (snapshots.hasData) {
            List<Dream> listDream = snapshots.data;

            if (listDream.isNotEmpty) {
              return _bodyWithDreamHomeFire(snapshots.data);
            } else {
              return _bodyWithOutDreamHome();
            }
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _bodyWithOutDreamHome() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(Utils.getPathAssetsImg("icon_with_out_dream.png")),
            SizedBox(
              height: 20,
            ),
            TextUtil.textDefault(
                "Vamos começar sua jornada para realizar seus sonhos. Agora adicione o seu primeiro!",
                align: TextAlign.center,
                fontSize: 16),
            SizedBox(
              height: 20,
            ),
            AppButtonDefault(
              label: "Adicionar primeiro sonho",
              onPressed: () => _startRegisterDream(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bodyWithDreamHomeFire(List<Dream> listDreams) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              pinned: false,
              title: new Text('Titulo'),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                child: TextUtil.textTitulo("Sonhos"),
              ),
              Container(
                height: 190.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(8),
                  children: _bloc.getlistCardDreamFire(context, listDreams),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: TextUtil.textTitulo("Etapas"),
              ),
              Container(
                margin: EdgeInsets.all(4),
                child: StreamBuilder(
                  stream: _bloc.streamChipSteps,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Wrap(children: snapshot.data);
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: TextUtil.textTitulo("Metas diárias"),
              ),
              Container(
                margin: EdgeInsets.all(4),
                child: StreamBuilder(
                    stream: _bloc.streamChipDailyGoal,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Wrap(children: snapshot.data);
                      }

                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ),
              Container(
                height: 260.0,
                child: StreamBuilder<List<Widget>>(
                  stream: _bloc.streamChartSteps,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.all(8),
                        children: snapshot.data,
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }

  _startRegisterDream(BuildContext context) {
    RegisterDreamPage registerDreamPage = RegisterDreamPage();
    push(context, registerDreamPage, isReplace: true);
  }
}
