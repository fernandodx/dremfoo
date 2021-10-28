import 'package:image_picker/image_picker.dart';

abstract class IUploadImageDataSource {

  Future<XFile?> chooseImageGallery({double maxWidth, int imageQuality});

  Future<XFile?> chooseImageCamera({double maxWidth, int imageQuality});


}