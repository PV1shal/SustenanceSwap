import 'package:cloud_firestore/cloud_firestore.dart';
import 'post.dart';
import 'user.dart';

// Represents a notification object with all the required fields
class MyNotification {
  /// String, type of notification
  final String type;

  /// UserModel instance
  final UserModel user;

  /// PostModel instance
  final PostModel post;

  /// is New notification, boolean
  final bool isNew;

  /// timestamp of showing notification
  final Timestamp timestamp;

  /// constructor of MyNotification
  MyNotification({
    required this.type,
    required this.user,
    required this.post,
    required this.isNew,
    required this.timestamp,
  });
}

// This class provides methods to add, retrieve, and mark notifications as read in the Firestore database
class NotificationModel {
  final FirebaseFirestore firestore;

  NotificationModel({required this.firestore});

  // Adds a notification to the Firestore database for a specific user
  Future<void> addNotification(
      String userId, MyNotification notification) async {
    await firestore
        .collection("users")
        .doc(userId)
        .collection("notifications")
        .add({
      "type": notification.type,
      "user": notification.user.userID,
      "post": notification.post.postID,
      "isNew": notification.isNew,
      "timestamp": notification.timestamp,
    });
  }

  // Retrieves all notifications for a specific user from the Firestore database
  Future<List<MyNotification>> getNotifications(String userId) async {
    final snapshot = await firestore
        .collection("users")
        .doc(userId)
        .collection("notifications")
        .get();

    List<MyNotification> notifications = [];
    for (var doc in snapshot.docs) {
      if (!doc.exists) {
        print("Error: Document does not exist");
        continue;
      }

      try {
        String userField = doc.get("user");
        final user =
            await UserModel(userID: userField, fireBaseInstance: firestore)
                .getUserInfo();
        String postField = doc.get("post");
        final post =
            await PostModel.fetchPostById(postField, userId, firestore);
        String type = doc.get("type");
        bool isNew = doc.get("isNew");
        Timestamp timestamp = doc.get("timestamp");

        notifications.add(MyNotification(
          type: type,
          user: user,
          post: post,
          isNew: isNew,
          timestamp: timestamp,
        ));
      } catch (e) {
        print("Error while fetching notifications: $e");
      }
    }

    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return notifications;
  }

  // Marks all notifications for a specific user as read in the Firestore database
  Future<void> markNotificationAsRead(String userId) async {
    final snapshot = await firestore
        .collection("users")
        .doc(userId)
        .collection("notifications")
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({"isNew": false});
    }
  }
}
