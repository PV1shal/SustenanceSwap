import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:urban_sketchers/screens/upload.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'upload_test.mocks.dart' as base_mock;
import 'mock.dart';

/// security rules for fake firestore
final authUidDescription = '''
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}''';

/// mock Reference related to firestorage
MockReferencePlatform mockReference = MockReferencePlatform();

/// mock list result Reference related to firestorage
MockListResultPlatform mockListResultPlatform = MockListResultPlatform();

/// mock upload task related to firestorage
MockUploadTaskPlatform mockUploadTaskPlatform = MockUploadTaskPlatform();

/// mock download task related to firestorage
MockDownloadTaskPlatform mockDownloadTaskPlatform = MockDownloadTaskPlatform();

/// mock task snapshot related to firestorage
MockTaskSnapshotPlatform mockTaskSnapshotPlatform = MockTaskSnapshotPlatform();

/// mock image picker platform for pick image
class _MockImagePickerPlatform extends base_mock.MockImagePickerPlatform
    with MockPlatformInterfaceMixin {}

@GenerateMocks(<Type>[],
    customMocks: <MockSpec<dynamic>>[MockSpec<ImagePickerPlatform>()])
void main() async {
  late _MockImagePickerPlatform mockPlatform;
  late FirebaseStorage storage;
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseStorageMocks();

  setUpAll(() async {
    FirebaseStoragePlatform.instance = kMockStoragePlatform;
    await Firebase.initializeApp();

    storage = FirebaseStorage.instance;

    when(kMockStoragePlatform.ref(any)).thenReturn(mockReference);
    when(mockReference.child(testFullPath)).thenReturn(mockReference);
    when(mockUploadTaskPlatform.snapshot).thenReturn(mockTaskSnapshotPlatform);

    GeolocatorPlatform.instance = MockGeolocatorPlatform();
    GeocodingPlatform.instance = MockGeocodingPlatform();
    mockPlatform = _MockImagePickerPlatform();
    ImagePickerPlatform.instance = mockPlatform;

    when(mockPlatform.getImageFromSource(
            source: anyNamed('source'), options: anyNamed('options')))
        .thenAnswer((Invocation _) async =>
            Future.value(XFile('assets/images/defaultUser.png')));
  });
  group('pick image', () {
    testWidgets('upload a sketch on firebase', (WidgetTester tester) async {
      final auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          securityRules: authUidDescription,
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(MaterialApp(
          home: Upload(
        firebaseAuth: auth,
        firestore: firestore,
      )));

      // Checks that tappable nodes have a minimum size of 48 by 48 pixels
      // for Android in upload image
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));

      // Checks that tappable nodes have a minimum size of 44 by 44 pixels
      // for iOS in upload image
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));

      // Checks that touch targets with a tap or long press action are labeled.
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

      // Checks whether semantic nodes meet the minimum text contrast levels.
      // The recommended text contrast is 3:1 for larger text
      // (18 point and above regular).
      await expectLater(tester, meetsGuideline(textContrastGuideline));

      //check for upload image button
      var button = find.text("Upload Image");
      expect(button, findsOneWidget);
      await tester.tap(button);
      await tester.pump();

      // Checks that tappable nodes have a minimum size of 48 by 48 pixels
      // for Android in alert
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));

      // Checks that tappable nodes have a minimum size of 44 by 44 pixels
      // for iOS in alert
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));

      // Checks that touch targets with a tap or long press action are labeled.
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

      // Checks whether semantic nodes meet the minimum text contrast levels.
      // The recommended text contrast is 3:1 for larger text
      // (18 point and above regular).
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      //check for dialog having option to choose
      expect(find.byType(SimpleDialog), findsOneWidget);

      // check for cancel dialog option
      var cancel = find.text("Cancel");
      await tester.tap(cancel);
      await tester.pump();

      //reopen dialog for choosing image
      await tester.tap(button);
      await tester.pump();

      //choose image by mocking image picker
      var galleryButton = find.text("Image from Gallery");
      expect(galleryButton, findsOneWidget);
      await tester.tap(galleryButton);
      await tester.pumpAndSettle();

      // check for back button in top header as second widget loaded as post form
      var back = find.byIcon(Icons.arrow_back);
      expect(back, findsOneWidget);
      // Checks that tappable nodes have a minimum size of 48 by 48 pixels
      // for Android in preview post form
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));

      // Checks that tappable nodes have a minimum size of 44 by 44 pixels
      // for iOS in preview post form
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));

      // Checks that touch targets with a tap or long press action are labeled.
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

      // Checks whether semantic nodes meet the minimum text contrast levels.
      // The recommended text contrast is 3:1 for larger text
      // (18 point and above regular).
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await tester.tap(back); //clicked back
      await tester.pump();

      //reopen dialog for choosing image
      await tester.tap(button);
      await tester.pump();

      //choose again image by mocking image picker
      await tester.tap(galleryButton);
      await tester.pumpAndSettle();

      //check for done icon on top header and tap on it to save on fake firestore with fake auth
      var done = find.byIcon(Icons.done);
      expect(done, findsOneWidget);
      await tester.tap(done);

      //click on button for using current location by mocking geolocator and geocoding
      var location = find.byIcon(Icons.my_location);
      expect(location, findsOneWidget);
      await tester.tap(location); //clicked button
      await tester.pump();

      //check for privacy option
      var dropdown = find.byIcon(Icons.keyboard_arrow_down);
      expect(dropdown, findsOneWidget);

      //check for done icon on top header and tap on it to save on fake firestore with fake auth
      expect(done, findsOneWidget);
      await tester.tap(done);
      await tester.pump();

      handle.dispose();
    });
  });
}

class MockGeocodingPlatform extends Mock
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        GeocodingPlatform {
  @override
  Future<List<Location>> locationFromAddress(
    String address, {
    String? localeIdentifier,
  }) async {
    return [mockLocation];
  }

  @override
  Future<List<Placemark>> placemarkFromCoordinates(
    double latitude,
    double longitude, {
    String? localeIdentifier,
  }) async {
    return [mockPlacemark];
  }
}

class MockGeolocatorPlatform extends Mock
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        GeolocatorPlatform {
  @override
  Future<LocationPermission> checkPermission() =>
      Future.value(LocationPermission.whileInUse);

  @override
  Future<LocationPermission> requestPermission() =>
      Future.value(LocationPermission.whileInUse);

  @override
  Future<bool> isLocationServiceEnabled() => Future.value(true);

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) =>
      Future.value(mockPosition);

  @override
  Future<LocationAccuracyStatus> getLocationAccuracy() =>
      Future.value(LocationAccuracyStatus.reduced);

  @override
  Future<LocationAccuracyStatus> requestTemporaryFullAccuracy({
    required String purposeKey,
  }) =>
      Future.value(LocationAccuracyStatus.reduced);

  @override
  Stream<Position> getPositionStream({
    LocationSettings? locationSettings,
  }) {
    return super.noSuchMethod(
      Invocation.method(
        #getPositionStream,
        null,
        <Symbol, Object?>{
          #desiredAccuracy: locationSettings?.accuracy ?? LocationAccuracy.best,
          #distanceFilter: locationSettings?.distanceFilter ?? 0,
          #timeLimit: locationSettings?.timeLimit ?? 0,
        },
      ),
      returnValue: Stream.value(mockPosition),
    );
  }

  @override
  Stream<ServiceStatus> getServiceStatusStream() {
    return super.noSuchMethod(
      Invocation.method(
        #getServiceStatusStream,
        null,
      ),
      returnValue: Stream.value(ServiceStatus.enabled),
    );
  }
}

Position get mockPosition => Position(
      latitude: 52.561270,
      longitude: 5.639382,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        500,
        isUtc: true,
      ),
      altitude: 3000.0,
      accuracy: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );

final mockLocation = Location(
  latitude: 52.2165157,
  longitude: 6.9437819,
  timestamp: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
);

final mockPlacemark = Placemark(
    administrativeArea: 'Overijssel',
    country: 'Netherlands',
    isoCountryCode: 'NL',
    locality: 'Enschede',
    name: 'Gronausestraat',
    postalCode: '',
    street: 'Gronausestraat 710',
    subAdministrativeArea: 'Enschede',
    subLocality: 'Enschmarke',
    subThoroughfare: '',
    thoroughfare: 'Gronausestraat');
