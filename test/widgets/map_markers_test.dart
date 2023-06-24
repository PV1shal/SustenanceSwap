import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urban_sketchers/widgets/map_markers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import '../screens/mock.dart';

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
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseStorageMocks();
  setUpAll(() async {
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
  });

  test('map markers ...', () async {
    final snapshot = await firestore.collection("posts").get();
    getMarkers(snapshot.docs, CustomInfoWindowController(), firestore, auth);
  });
}
