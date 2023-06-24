import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:mockito/mockito.dart';
import 'package:urban_sketchers/utils/image_utils.dart';
import 'package:urban_sketchers/utils/update_profile_pic.dart';
import 'package:image_picker/image_picker.dart' as image_picker;

import '../screens/mock.dart';
import '../screens/upload_test.mocks.dart';
import 'update_profile_pic_test.mocks.dart' as base_mock;

import 'dart:async';

import 'package:mockito/annotations.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// Import the necessary mocks for Firebase Firestore and Firebase Storage
class MockFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockStorageReference extends Mock implements Reference {}

class MockTaskSnapshot extends Mock implements TaskSnapshot {}

class MockUploadTask extends Mock implements UploadTask {}

// / mock image picker platform for pick image
class _MockImagePickerPlatform extends base_mock.MockImagePickerPlatform
    with MockPlatformInterfaceMixin {}

@GenerateMocks(<Type>[],
    customMocks: <MockSpec<dynamic>>[MockSpec<ImagePickerPlatform>()])
void main() {
  setupFirebaseStorageMocks();

  late FirebaseStorage storage;
  // MockFirestore _firestore;
  // MockDocumentSnapshot mockDocumentSnapshot;
  // MockCollectionReference mockCollectionReference;
  // MockDocumentReference mockDocumentReference;
  // MockFirebaseStorage _storage;
  // MockStorageReference _storageReference;
  // MockTaskSnapshot _taskSnapshot;
  // MockUploadTask _uploadTask;
  late _MockImagePickerPlatform mockPlatform;

  group('Uploading profile pic', () {
    setUpAll(() async {
      await Firebase.initializeApp();
      mockPlatform = _MockImagePickerPlatform();
      ImagePickerPlatform.instance = mockPlatform;
      storage = MockFirebaseStorage();
      // _firestore = MockFirestore();
      // _storage = MockFirebaseStorage();
      // mockCollectionReference = MockCollectionReference();
      // mockDocumentReference = MockDocumentReference();
      // mockDocumentSnapshot = MockDocumentSnapshot();
      // _storageReference = MockStorageReference();
      // _taskSnapshot = MockTaskSnapshot();
      // _uploadTask = MockUploadTask();
      storage = FirebaseStorage.instance;
    });

    testWidgets('Testing Profile Pic upload', (WidgetTester tester) async {
      // Build the widget tree for the test
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(builder: (BuildContext context) {
            return ElevatedButton(
                onPressed: () async {
                  final String downloadURL = await uploadImage(
                    File('assets/images/defaultUser.png'),
                    'test',
                    storage,
                  );

                  expect(downloadURL, isNotNull);
                },
                child: const Text("Upload"));
          }),
        ),
      ));

      // Tap the "Upload" button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
    });

    testWidgets('Testing Profile Pic upload', (WidgetTester tester) async {
      // Mock the necessary classes
      // final ImagePicker mockedImagePicker = MockImagePicker();
      // final XFile mockedXFile = MockXFile();

      when(mockPlatform.getImageFromSource(
              source: anyNamed('source'), options: anyNamed('options')))
          .thenAnswer((Invocation _) async =>
              Future.value(XFile('assets/images/defaultUser.png')));

      // Build the widget tree for the test
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(builder: (BuildContext context) {
            return ElevatedButton(
                onPressed: () async {
                  // Call the uploadImage function with mock data to test its output
                  updateProfilePic(
                    context,
                    'test',
                    storage,
                  );
                },
                child: const Text("Upload"));
          }),
        ),
      ));

      // Tap the "Upload" button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
    });
  });
}
