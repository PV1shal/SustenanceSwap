import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urban_sketchers/models/user.dart';

void main() {
  group('UserModel', () {
    final instance = FakeFirebaseFirestore();
    instance.collection('users').doc("test").set({
      'Username': 'Bob',
      'Full name': 'tester bob',
      'bio': 'This is a Bio',
      'Profile Pic': null
    });
    instance.collection('users').doc("test").collection('posts').add({
      "caption": "",
      "comments": {"test": "test"},
      "latitude": 0.0,
      "longitude": 0.0,
      "likes": [],
      "mediaUrl": "www.test.com",
      "ownerId": "1",
      "postId": "1",
      "timestamp": Timestamp.fromDate(DateTime(2022))
    });

    test('getUserInfo should get user info from Firestore', () async {
      final snapshot = await instance.collection('users').get();
      UserModel user = UserModel(
          userID: snapshot.docs.first.id,
          fireBaseInstance: instance);
      user.getUserInfo();
      expect(user.posts, isNotNull);
    });

    test('set Username', () async {
      final snapshot = await instance.collection('users').get();
      UserModel user = UserModel(
          userID: snapshot.docs.first.id,
          fireBaseInstance: instance);

      user.setUserName = "test";
      expect(user.username, "test");
    });

    test('set Full name', () async {
      final snapshot = await instance.collection('users').get();
      UserModel user = UserModel(
          userID: snapshot.docs.first.id,
          fireBaseInstance: instance);

      user.setFullName = "test";
      expect(user.fullName, "test");
    });

    test('set Bio', () async {
      final snapshot = await instance.collection('users').get();
      UserModel user = UserModel(
          userID: snapshot.docs.first.id,
          fireBaseInstance: instance);

      user.setBio = "test";
      expect(user.bio, "test");
    });
  });
}
