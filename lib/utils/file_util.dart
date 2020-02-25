import 'dart:io';
import 'dart:convert';

class FileUtil {

   static String fileToStringBase64(File file) {
    List<int> bytes = file.readAsBytesSync();
    return base64Encode(bytes);

  }


}