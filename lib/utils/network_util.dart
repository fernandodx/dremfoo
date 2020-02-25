import 'package:connectivity/connectivity.dart';

class NetworkUtil {

  static Future<bool> isConnect() async {
   var result = await (Connectivity().checkConnectivity());
   return result != ConnectivityResult.none;
  }

  static void listenerConnect(void Function(ConnectivityResult) result) {
    Connectivity().onConnectivityChanged.listen(result);
  }

  static Future<bool> isConnectWifi() async {
    var result = await (Connectivity().checkConnectivity());
    return result == ConnectivityResult.wifi;
  }

  static Future<bool> isConnectNetworkPhone() async {
    var result = await (Connectivity().checkConnectivity());
    return result == ConnectivityResult.mobile;
  }



}