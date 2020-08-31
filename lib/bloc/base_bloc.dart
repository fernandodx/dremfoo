import 'dart:async';

import 'package:dremfoo/utils/text_util.dart';
import 'package:dremfoo/utils/utils.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseBloc {

  static String descriptionLoading = "Carregando...";
  final _loadingStreamController = StreamController<bool>.broadcast();

  getSimpleLoadingWidget({double size = 150}) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: size,
            height: size,
            child: Center(
              child: FlareActor(
                Utils.getPathAssetsAnim("loading-load.flr"),
                shouldClip: true,
                animation: "load",
              ),
            ),
          ),
        ],
      ),
    );
  }

  getLoadingFindWidget({String description = "Carregando...", double size = 100}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black54,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            child: Center(
              child: FlareActor(
                Utils.getPathAssetsAnim("loading-walking.flr"),
                shouldClip: true,
                animation: "walking",
              ),
            ),
          ),
          TextUtil.textTitulo(description, color: Colors.white),
        ],
      ),
    );
  }

  showLoading({String description = "Carregando..."}) {
    descriptionLoading = description;
    _loadingStreamController.sink.add(true);
  }

  hideLoading() {
    _loadingStreamController.sink.add(false);
  }

  dispose() {
    _loadingStreamController.close();
  }

  loading() {
    return StreamBuilder(
      stream: _loadingStreamController.stream,
      builder: (context, snapshop) {
        var isShow = false;

        if (snapshop.hasData) {
          isShow = snapshop.data;
        }

        return Visibility(
          visible: isShow,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black54,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  child: Center(
                    child: FlareActor(
                      Utils.getPathAssetsAnim("loading_walk-defauld.flr"),
                      shouldClip: true,
                      animation: "defauld",
                    ),
                  ),
                ),
                TextUtil.textTitulo(descriptionLoading, color: Colors.white),
              ],
            ),
          ),
        );
      },
    );
  }
}
