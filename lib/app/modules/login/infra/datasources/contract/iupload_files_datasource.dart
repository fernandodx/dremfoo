import 'dart:io';

abstract class IUploadFilesDataSource {

  Future<String> uploadFileAcountUser(String fireBaseUserUid, String nameFolder, File file, String id);

}