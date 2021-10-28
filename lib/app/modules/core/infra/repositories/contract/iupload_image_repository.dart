import 'dart:io';


abstract class IUploadImageRepository {

  Future<File> chooseImageGallery({double maxWidth, int imageQuality});

  Future<File> chooseImageCamera({double maxWidth, int imageQuality});

}