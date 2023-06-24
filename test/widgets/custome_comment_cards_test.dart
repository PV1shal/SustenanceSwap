import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import 'package:urban_sketchers/models/post.dart';
import 'package:urban_sketchers/models/user.dart';
import 'package:urban_sketchers/widgets/comment_card.dart';
import 'package:urban_sketchers/widgets/individual_post_view.dart';

void main() {
  group('Individual Page', () {
    final instance = FakeFirebaseFirestore();
    late PostModel post;
    QuerySnapshot<Map<String, dynamic>> userSnapshot;
    late UserModel user;
    instance.collection('users').doc("test").set({
      'Username': 'Bob',
      'Full name': 'tester bob',
      'bio': 'This is a Bio',
      'Profile Pic': "null"
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
      "mediaUrl": "test.jpg",
      "ownerId": "test",
      "postId": "testpost",
      "timestamp": Timestamp.fromDate(DateTime(2022))
    });
    instance
        .collection('users')
        .doc("test")
        .collection('posts')
        .doc("testpost")
        .collection("comments")
        .add({
      "ownerId": "test",
      "comment": "this is a comment",
    });
    setUpAll(() async {
      final snapshot = await instance
          .collection('users')
          .doc("test")
          .collection("posts")
          .get();
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

      userSnapshot = await instance.collection('users').get();
      user =
          UserModel(userID: snapshot.docs.first.id, fireBaseInstance: instance);
      user.getUserInfo();
    });
    testWidgets('showPost test', (WidgetTester tester) async {
      mockNetworkImagesFor(() async {
        await tester.pumpWidget(MaterialApp(
          home: customCommentCards("test", post.postID, instance),
        ));
        await tester.pumpAndSettle();
      });
    });
  });
}
