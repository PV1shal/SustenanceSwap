import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:urban_sketchers/models/post.dart';
import 'package:urban_sketchers/screens/custom_marker_window.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'mock.dart';

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
  });

  testWidgets(
      'testing for empty posts without owner info for marker info window',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: CustomMarkerWindow(
        postsList: [],
        firebaseAuth: auth,
        firebaseFirestore: firestore,
      ),
    )));
  });

  testWidgets('testing for 1 post without owner info for marker info window',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: CustomMarkerWindow(
        postsList: [
          PostModel(
            caption: 'ambika',
            lat: 0.0,
            fireStoreInstance: firestore,
            likes: [1],
            long: 0.0,
            mediaUrl: "",
            ownerId: '1',
            postID: 'post id 1',
            timestamp: Timestamp.now(),
          )
        ],
        firebaseAuth: auth,
        firebaseFirestore: firestore,
      ),
    )));
  });

  testWidgets('testing for 1 post with owner info for marker info window',
      (tester) async {
    final uid = auth.currentUser!.uid;
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomMarkerWindow(
              postsList: [
                PostModel(
                  caption: 'ambika',
                  lat: 0.0,
                  fireStoreInstance: firestore,
                  likes: [1],
                  long: 0.0,
                  mediaUrl: "assets/images/defaultUser.png",
                  ownerId: uid,
                  postID: 'post id 1',
                  timestamp: Timestamp.now(),
                )
              ],
              firebaseAuth: auth,
              firebaseFirestore: firestore,
            ),
          ),
        ),
      );
      await tester.idle();
      await tester.pump();

      var postKey = find.byKey(const Key('post id 1'));
      expect(postKey, findsOneWidget);
    });
  });
}
