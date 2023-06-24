import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urban_sketchers/models/notification.dart';
import 'package:urban_sketchers/models/post.dart';
import 'package:urban_sketchers/models/user.dart';

void main() {
  late FirebaseFirestore instance;
  late NotificationModel notificationModel;
  late UserModel mockUser;
  late PostModel mockPost;

  setUp(() async {
    instance = FakeFirebaseFirestore();
    notificationModel = NotificationModel(firestore: instance);

    // Create fake UserModel and PostModel without using mockito
    mockUser = UserModel(userID: 'mockUser', fireBaseInstance: instance);
    mockPost = PostModel(
      caption: 'mockPostCaption',
      lat: 0.0,
      long: 0.0,
      likes: [],
      mediaUrl: 'mockPostMediaUrl',
      ownerId: 'mockPostOwnerId',
      postID: 'mockPost',
      timestamp: Timestamp.now(),
      fireStoreInstance: instance,
    );
  });

  test('getNotifications', () async {
    final timestamp = Timestamp.now();

    await instance
        .collection('users')
        .doc('mockUserId')
        .collection('notifications')
        .add({
      'type': 'liked',
      'user': 'mockUser',
      'post': 'mockPost',
      'isNew': true,
      'timestamp': timestamp,
    });

    final notifications =
        await notificationModel.getNotifications('mockUserId');

    expect(notifications.length, 1);
    expect(notifications.first.type, 'liked');
    expect(notifications.first.user.userID, 'mockUser');
    expect(notifications.first.post.postID, 'mockPost');
    expect(notifications.first.isNew, true);
    expect(notifications.first.timestamp, timestamp);
  });

  test('markNotificationAsRead', () async {
    final timestamp = Timestamp.now();

    await instance
        .collection('users')
        .doc('mockUserId')
        .collection('notifications')
        .add({
      'type': 'liked',
      'user': 'mockUser',
      'post': 'mockPost',
      'isNew': true,
      'timestamp': timestamp,
    });

    final snapshotBefore = await instance
        .collection('users')
        .doc('mockUserId')
        .collection('notifications')
        .get();
    final docId = snapshotBefore.docs.first.id;

    await notificationModel.markNotificationAsRead('mockUserId');

    final snapshotAfter = await instance
        .collection('users')
        .doc('mockUserId')
        .collection('notifications')
        .get();

    expect(snapshotAfter.docs.length, 1);
    expect(snapshotAfter.docs.first.get('type'), 'liked');
    expect(snapshotAfter.docs.first.get('user'), 'mockUser');
    expect(snapshotAfter.docs.first.get('post'), 'mockPost');
    expect(snapshotAfter.docs.first.get('isNew'), false);
    expect(snapshotAfter.docs.first.get('timestamp'), timestamp);
  });
}
