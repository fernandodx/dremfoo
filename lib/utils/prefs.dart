
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {

  static Future<bool> getBool(String key, bool defaultValue) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future<int> getInt(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  static Future<String> getString(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  static Future<List<String>> getListString(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? null;
  }

  static void putBool(String key, bool valor) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, valor);
  }

  static void putInt(String key, int valor) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, valor);
  }

  static void putString(String key, String valor) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(key, valor);
  }

  static void putListString(String key, List<String> valor) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, valor);
  }

  static void removePref(String key) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }


}