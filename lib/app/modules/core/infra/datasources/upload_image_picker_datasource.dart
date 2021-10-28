import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/infra/datasources/contract/iupload_image_datasource.dart';
import 'package:dremfoo/app/resources/constants.dart';
import 'package:image_picker/image_picker.dart';

class UploadImagePickerDataSource extends IUploadImageDataSource {

  ImagePicker _imagePicker = ImagePicker();


  @override
  Future<XFile?> chooseImageGallery({double maxWidth = 300, int imageQuality = 90}) {
    return _imagePicker.pickImage(source: ImageSource.gallery, maxWidth: maxWidth, imageQuality: imageQuality);
  }

  @override
  Future<XFile?> chooseImageCamera({double maxWidth = 300, int imageQuality = 90}) {
    return _imagePicker.pickImage(source: ImageSource.camera, maxWidth: maxWidth, imageQuality: imageQuality);
  }





}