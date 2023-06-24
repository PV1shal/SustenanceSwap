import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urban_sketchers/models/post.dart';

void main() {
  group('Post Model', () {
    final instance = FakeFirebaseFirestore();
    late PostModel post;
    instance.collection('users').doc("test").set({
      'Username': 'Bob',
      'Full name': 'tester bob',
      'bio': 'This is a Bio',
      'Profile Pic': null
    });
    instance
        .collection('users')
        .doc("test")
        .collection('posts')
        .doc("testpost")
        .set({
      "caption": "",
      "latitude": 0.0,
      "longitude": 0.0,
      "likes": [],
      "mediaUrl": "www.test.com",
      "ownerId": "test",
      "postId": "testpost",
      "timestamp": Timestamp.fromDate(DateTime(2022))
    });

    setUpAll(() async {
      final snapshot = await instance
          .collection('users')
          .doc("test")
          .collection("posts")
          .get();
      // print(snapshot.docs.first.id);
      // print(snapshot.docs.first.data());
      post = PostModel(
          caption: snapshot.docs.first.get("caption"),
          lat: snapshot.docs.first.get("latitude"),
          long: snapshot.docs.first.get("longitude"),
          likes: snapshot.docs.first.get("likes"),
          mediaUrl: snapshot.docs.first.get("mediaUrl"),
          ownerId: snapshot.docs.first.get("ownerId"),
          postID: snapshot.docs.first.get("postId"),
          timestamp: snapshot.docs.first.get("timestamp"),
          fireStoreInstance: instance);
    });

    test('testing add likes', () async {
      post.addLikes("tester2");
      expect(post.likes, isNotEmpty);
    });
    test('test remove likes', () async {
      post.removeLikes("tester2");
      expect(post.likes, isEmpty);
    });
    test('add Comments', () async {
      // post.addComment("userID", "test", "testPost", "Test comment");
      expect(post.addComment("userID", "test", "testPost", "Test comment"),
          completes);
    });
  });
}
