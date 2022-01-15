import 'dart:convert';

import 'package:dremfoo/app/modules/core/infra/datasources/contract/ishared_prefs_datasource.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/contract/ishared_prefs_repository.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';

class SharedPrefsRepository implements ISharedPrefsRepository {

  ISharedPrefsDatasource _sharedDatasource;
  SharedPrefsRepository(this._sharedDatasource);

  @override
  Future<bool?> getBool(String key, bool? defaultValue) async {
    try{
      return _sharedDatasource.getBool(key, defaultValue);
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  @override
  Future<int> getInt(String key) async {
    try{
      return _sharedDatasource.getInt(key);
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  @override
  Future<List<String>?> getListString(String key) async {
    try{
      return _sharedDatasource.getListString(key);
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  @override
  Future<String> getString(String key) async {
    try{
      String value = await _sharedDatasource.getString(key);
      var bytes = base64.decode(value);
      return Utf8Decoder().convert(bytes);
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  @override
  Future<void> putBool(String key, bool valor) async {
    try{
      return _sharedDatasource.putBool(key, valor);
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  @override
  Future<void> putInt(String key, int valor) async {
    try{
      return _sharedDatasource.putInt(key, valor);
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  @override
  Future<void> putListString(String key, List<String> valor) async {
    try{
      return _sharedDatasource.putListString(key, valor);
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  @override
  Future<void> putString(String key, String value) async {
    try{
      var bytes = Utf8Encoder().convert(value);
      var valueBase64 = base64.encode(bytes);
      return _sharedDatasource.putString(key, valueBase64);
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  @override
  Future<void> removePref(String key) async {
   try{
     return _sharedDatasource.removePref(key);
   } catch(error, stack) {
     CrashlyticsUtil.logErro(error, stack);
     throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
   }
  }

}