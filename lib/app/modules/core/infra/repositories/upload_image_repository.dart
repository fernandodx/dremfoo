import 'dart:io';

import 'package:cross_file/src/types/interface.dart';
import 'package:dremfoo/app/modules/core/infra/datasources/contract/iupload_image_datasource.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/contract/iupload_image_repository.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class UploadImageRepository extends IUploadImageRepository {

  IUploadImageDataSource _imageDataSource;
  UploadImageRepository(this._imageDataSource);

  @override
  Future<File> chooseImageCamera({double? maxWidth = 300, int? imageQuality = 90}) async {
    try{
      var xfile = await _imageDataSource.chooseImageCamera(
          maxWidth: maxWidth!,
          imageQuality: imageQuality!);

      if(xfile != null && xfile.path.isNotEmpty) {
        File compressedImg = await FlutterNativeImage.compressImage(xfile.path,
            quality: imageQuality,
            targetWidth: maxWidth.toInt(),
            targetHeight: maxWidth.toInt());
        return compressedImg;
      }else{
        throw new RevoExceptions.msgToUser(error: Exception("xfile == null"), msg: "Ops! Não foi possível carregar a imagem");
      }

    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  @override
  Future<File> chooseImageGallery({double? maxWidth = 300, int? imageQuality = 90}) async {
    try{
      var xfile = await _imageDataSource.chooseImageGallery(
          maxWidth: maxWidth!,
          imageQuality: imageQuality!);

      if(xfile != null && xfile.path.isNotEmpty) {
        File compressedImg = await FlutterNativeImage.compressImage(xfile.path,
            quality: imageQuality,
            targetWidth: maxWidth.toInt(),
            targetHeight: maxWidth.toInt());
        return compressedImg;
      }else{
        throw new RevoExceptions.msgToUser(error: Exception("xfile == null"), msg: "Ops! Não foi possível carregar a imagem");
      }

    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

}