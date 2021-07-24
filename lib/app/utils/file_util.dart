import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart' as path_provider;

class FileUtil {


  static Future<String> pathFileTemp() async {
    var dateTime = DateTime.now().millisecondsSinceEpoch;
    var directory = await path_provider.getTemporaryDirectory();
    return "${directory.path}/$dateTime/";
  }

  static String fileToStringBase64(File file) {
    List<int> bytes = file.readAsBytesSync();
    return base64Encode(bytes);

  }


}