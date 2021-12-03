import 'dart:async';

import 'package:dremfoo/app/modules/core/infra/datasources/contract/ishared_prefs_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefdDatasource implements ISharedPrefsDatasource {

  Completer<SharedPreferences> _instance = Completer<SharedPreferences>();

  _init() async {
    var prefs = await SharedPreferences.getInstance();
    _instance.complete(prefs);
  }


  SharedPrefdDatasource(){
    _init();
  }

  @override
  Future<bool> getBool(String key, bool defaultValue) async {
    var prefs = await _instance.future;
    return prefs.getBool(key) ?? defaultValue;
  }

  @override
  Future<int> getInt(String key) async {
    var prefs = await _instance.future;
    return prefs.getInt(key) ?? 0;
  }

  @override
  Future<List<String>?> getListString(String key) async {
    var prefs = await _instance.future;
    return prefs.getStringList(key) ?? null;
  }

  @override
  Future<String> getString(String key) async {
    var prefs = await _instance.future;
    return prefs.getString(key) ?? "";
  }

  @override
  Future<void> putBool(String key, bool valor) async {
    var prefs = await _instance.future;
    prefs.setBool(key, valor);
  }

  @override
  Future<void> putInt(String key, int valor) async {
    var prefs = await _instance.future;
    prefs.setInt(key, valor);
  }

  @override
  Future<void> putListString(String key, List<String> valor) async {
    var prefs = await _instance.future;
    prefs.setStringList(key, valor);
  }

  @override
  Future<void> putString(String key, String valor) async {
    var prefs = await _instance.future;
    prefs.setString(key, valor);
  }

  @override
  Future<void> removePref(String key) async {
    var prefs = await _instance.future;
    prefs.remove(key);
  }

}