abstract class ISharedPrefsDatasource {

  Future<bool> getBool(String key, bool defaultValue);

  Future<int> getInt(String key);

  Future<String> getString(String key);

  Future<List<String>?> getListString(String key);

  Future<void> putBool(String key, bool valor);

  Future<void> putInt(String key, int valor);

  Future<void> putString(String key, String valor);

  Future<void> putListString(String key, List<String> valor);

  Future<void> removePref(String key);

}