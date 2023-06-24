import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:provider/provider.dart';
import 'package:urban_sketchers/models/post.dart';
import 'package:urban_sketchers/models/user.dart';
import 'package:urban_sketchers/screens/timeline.dart';
import 'package:mockito/mockito.dart';
import 'mock.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'fake_map_controllers.dart';

final userIdTokenResult = IdTokenResult({
  'authTimestamp': DateTime.now().millisecondsSinceEpoch,
  'claims': {'role': 'admin'},
  'token': 'some_long_token',
  'expirationTime':
      DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch,
  'issuedAtTimestamp':
      DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch,
  'signInProvider': 'phone',
});
void main() {
  late MockUser tUser;
  late MockFirebaseAuth auth;
  late FakeFirebaseFirestore firestore;
  late dynamic userModel;
  setupFirebaseStorageMocks();
  late TestGoogleMapsFlutterPlatform platform;
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    tUser = MockUser(
      isAnonymous: false,
      email: 'bob@thebuilder.com',
      displayName: 'Bob Builder',
      phoneNumber: '0800 I CAN FIX IT',
      photoURL: 'http://photos.url/bobbie.jpg',
      refreshToken: 'some_long_token',
      idTokenResult: userIdTokenResult,
    );
    auth = MockFirebaseAuth(signedIn: true, mockUser: tUser);
    firestore = FakeFirebaseFirestore();
    await firestore.collection('users').doc(auth.currentUser!.uid).set({
      'Username': 'Bob',
      'Full name': 'tester bob',
      'bio': 'This is a Bio',
      'Profile Pic': null
    });
    await firestore.collection('posts').doc("1").set({
      'postId': "1",
      'ownerId': auth.currentUser!.uid,
      'mediaUrl': "www.tect.com",
      'caption': "caption",
      'latitude': 0.0,
      'longitude': 120.0,
      'timestamp': DateTime.now(),
      'privacy': "Public",
      'likes': [],
    });
    await firestore.collection('posts').doc("2").set({
      'postId': "2",
      'ownerId': auth.currentUser!.uid,
      'mediaUrl': "www.google.com",
      'caption': "caption 2",
      'latitude': 0.0,
      'longitude': 120.0,
      'timestamp': DateTime.now(),
      'privacy': "Public",
      'likes': [],
    });
    GeolocatorPlatform.instance = MockGeolocatorPlatform();
    GeocodingPlatform.instance = MockGeocodingPlatform();
    // Use a mock platform so we never need to hit the MethodChannel code.
    platform = TestGoogleMapsFlutterPlatform();
    GoogleMapsFlutterPlatform.instance = platform;
  });

  testWidgets('timeline widget testing', (tester) async {
    var timeline = Timeline(
      firebaseAuth: auth,
      firebaseFirestore: firestore,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: timeline,
        ),
      ),
    );

    await tester.idle();
    await tester.pump();
    var map = find.byKey(const Key("app-map"));
    expect(map, findsOneWidget);

    var locTextField = find.byKey(const Key('location-field'));
    expect(locTextField, findsOneWidget);
    await tester.enterText(locTextField, 'hi');

    var searchLoc = find.byIcon(Icons.search);
    expect(searchLoc, findsOneWidget);
    await tester.tap(searchLoc);
    var locationIcon = find.byIcon(Icons.location_on);
    expect(locationIcon, findsOneWidget);
    await tester.tap(locationIcon);
  });

  Future<void> createFakeNotifications() async {
    userModel = UserModel(
      userID: 'testUserID',
      fireBaseInstance: firestore,
    );

    final post = PostModel(
      caption: 'testCaption',
      lat: 0.0,
      long: 0.0,
      likes: [],
      mediaUrl: 'http://photos.url/bobbie.jpg',
      ownerId: 'testUserID',
      postID: 'testPostID',
      timestamp: Timestamp.now(),
      fireStoreInstance: firestore,
    );

    await firestore.collection('users').doc("testUserID").set({
      'Username': 'testUser',
      'Full name': 'testUser',
      'bio': 'testBio',
      'Profile Pic': null
    });
    await firestore
        .collection('users')
        .doc("testUserID")
        .collection('posts')
        .doc("testPostID")
        .set({
      "caption": "",
      "comments": {"test": "test"},
      "latitude": 0.0,
      "longitude": 0.0,
      "likes": [],
      "mediaUrl": "http://photos.url/bobbie.jpg",
      "ownerId": "testUserID",
      "postId": "testPostID",
      "timestamp": Timestamp.fromDate(DateTime(2022))
    });

    await firestore
        .collection('users')
        .doc('testUserID')
        .collection('notifications')
        .doc('testNotification')
        .set({
      'type': 'liked',
      'user': userModel.userID,
      'post': post.postID,
      'isNew': true,
      'timestamp': Timestamp.now(),
    });
  }

  testWidgets('notification loading test', (widgetTester) async {
    await createFakeNotifications();
    var timeline = Timeline(
      firebaseAuth: auth,
      firebaseFirestore: firestore,
    );

    await widgetTester.pumpWidget(
      ChangeNotifierProvider<UserModel>.value(
        value: userModel,
        child: MaterialApp(
          home: Scaffold(
            body: timeline,
          ),
        ),
      ),
    );

    await widgetTester.idle();
    await widgetTester.pump();

    var notification = find.byIcon(Icons.notifications_on);
    expect(notification, findsOneWidget);
    await widgetTester.tap(notification);
    await widgetTester.pump();
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
