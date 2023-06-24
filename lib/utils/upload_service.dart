import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

/// This class is used for uploading file in file storage
class UploadFileService {
  /// instance of FirebaseStorage
  final FirebaseStorage storage;

  /// constructor of UploadFileService
  const UploadFileService({
    required this.storage,
  });

  /// function to upload a file in given storageRef with child as fileName and returns downloadURL
  Future<String> uploadFile(
      File image, String fileName, String storageRef) async {
    final Reference storageReference = storage.ref(storageRef);
    final Reference storeReference = storageReference.child(fileName);
    final UploadTask uploadTask = storeReference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }
}
