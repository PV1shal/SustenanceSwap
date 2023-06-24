import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urban_sketchers/models/notification.dart';
import 'package:urban_sketchers/models/post.dart';
import 'package:urban_sketchers/models/user.dart';
import 'package:urban_sketchers/screens/notificationpage.dart';
import 'package:urban_sketchers/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  late FirebaseFirestore instance;
  late NotificationModel notificationModel;

  setUp(() {
    instance = FakeFirebaseFirestore();
    notificationModel = NotificationModel(firestore: instance);
  });

  Widget createNotificationPage() => MaterialApp(
        home: NotificationPage(
          userID: 'testUserID',
          firestore: instance,
        ),
      );

  Future<void> createFakeNotifications() async {
    final user = UserModel(
      userID: 'testUserID',
      fireBaseInstance: instance,
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
      fireStoreInstance: instance,
    );

    await instance.collection('users').doc("testUserID").set({
      'Username': 'testUser',
      'Full name': 'testUser',
      'bio': 'testBio',
      'Profile Pic': null
    });
    await instance
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

    await instance
        .collection('users')
        .doc('testUserID')
        .collection('notifications')
        .doc('testNotification')
        .set({
      'type': 'liked',
      'user': user.userID,
      'post': post.postID,
      'isNew': true,
      'timestamp': Timestamp.now(),
    });
  }

  testWidgets('NotificationPage UI test', (WidgetTester tester) async {
    await createFakeNotifications();
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(createNotificationPage());
      await tester.pumpAndSettle();

      expect(find.text('Notifications'), findsOneWidget);

      await tester.pump(Duration.zero);

      final notifications = await tester
          .runAsync(() => notificationModel.getNotifications('testUserID'));

      expect(find.byType(ListTile), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      final containerColor = tester
          .widget<Container>(find
              .ancestor(
                  of: find.byType(ListTile), matching: find.byType(Container))
              .first)
          .color;
      expect(containerColor, AppColors.primaryFocusColor);
    });
  });
}
