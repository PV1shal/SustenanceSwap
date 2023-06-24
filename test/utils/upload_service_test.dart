import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:urban_sketchers/utils/upload_service.dart';
import '../screens/mock.dart';

MockReferencePlatform mockReference = MockReferencePlatform();
MockListResultPlatform mockListResultPlatform = MockListResultPlatform();
MockUploadTaskPlatform mockUploadTaskPlatform = MockUploadTaskPlatform();
MockDownloadTaskPlatform mockDownloadTaskPlatform = MockDownloadTaskPlatform();
MockTaskSnapshotPlatform mockTaskSnapshotPlatform = MockTaskSnapshotPlatform();
void main() {
  setupFirebaseStorageMocks();
  late FirebaseStorage storage;
  group('', () {
    setUpAll(() async {
      FirebaseStoragePlatform.instance = kMockStoragePlatform;
      await Firebase.initializeApp();

      storage = FirebaseStorage.instance;

      when(kMockStoragePlatform.ref(any)).thenReturn(mockReference);
      when(mockReference.child(testFullPath)).thenReturn(mockReference);
      when(mockUploadTaskPlatform.snapshot)
          .thenReturn(mockTaskSnapshotPlatform);
    });

    test(('Upload file testing'), () async {
      final UploadFileService uploadRepository = UploadFileService(
        storage: storage,
      );

      String url = await uploadRepository.uploadFile(
        File('assets/images/defaultUser.png'),
        testFullPath,
        "/posts",
      );

      expect(url, "$kBucket/$testName");
    });
  });
}
