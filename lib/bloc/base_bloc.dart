import 'dart:async';

import 'package:dremfoo/resources/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class BaseBloc {

  final _loadingStreamController = StreamController<bool>.broadcast();


  showLoading(){
    _loadingStreamController.sink.add(true);
  }

  hideLoading(){
    _loadingStreamController.sink.add(false);
  }

  loading() {
    return StreamBuilder(
      stream: _loadingStreamController.stream,
      builder: (context, snapshop){

        var isShow = false;

        if(snapshop.hasData){
          isShow = snapshop.data;
        }

        return Visibility(
          visible: isShow,
          child: Container(
            color: Colors.black26,
            child: Center(
              child: Loading(
                indicator: BallPulseIndicator(),
                size: 100.0,
                color: AppColors.colorPrimaryLight,
              ),
            ),
          ),
        );
      },
    );
  }
}
