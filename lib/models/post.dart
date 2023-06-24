import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'notification.dart';
import 'user.dart';

/// Post Model used to store post data retrieved from Firestore.
class PostModel extends ChangeNotifier {
  /// Caption of the post.
  late String caption;

  /// Latitude of the Post.
  late double lat;

  /// Longitude of the Post.
  late double long;

  /// List of UIDs of users who like the post.
  late List<dynamic> likes;

  /// Firebase url of the post.
  late String mediaUrl;

  /// UID of who posted the post.
  late String ownerId;

  /// Document ID of the post.
  late String postID;

  /// Timestamp of when the post was uploaded.
  late Timestamp timestamp;

  final fireStoreInstance;

  /// NotificationModel for updating and getting notifications.
  late NotificationModel _notificationModel;

  PostModel(
      {required this.caption,
      // required this.comments,
      required this.lat,
      required this.long,
      required this.likes,
      required this.mediaUrl,
      required this.ownerId,
      required this.postID,
      required this.timestamp,
      required this.fireStoreInstance}) {
    _notificationModel = NotificationModel(firestore: fireStoreInstance);
  }

  /// Adds a user to likes list in post collection.
  /// Takes [uid] of the user to appened to the likes list.
  /// FirebaseFirestore instance is called store the data back into DB.
  Future<void> addLikes(String uid) async {
    likes.add(uid);
    fireStoreInstance
        .collection("users")
        .doc(ownerId)
        .collection("posts")
        .doc(postID)
        .update({"likes": likes});
    notifyListeners();

    if (uid == ownerId) {
      return;
    }

    final user =
        await UserModel(userID: uid, fireBaseInstance: fireStoreInstance)
            .getUserInfo();

    final notification = MyNotification(
      type: 'liked',
      user: user,
      post: this,
      isNew: true,
      timestamp: Timestamp.now(),
    );

    await _notificationModel.addNotification(ownerId, notification);

    notifyListeners();
  }

  /// Removes a user to likes list in post collection.
  /// Takes [uid] of the user to remove from the likes list.
  /// FirebaseFirestore instance is called store the data back into DB.
  void removeLikes(String uid) {
    likes.remove(uid);
    fireStoreInstance
        .collection("users")
        .doc(ownerId)
        .collection("posts")
        .doc(postID)
        .update({"likes": likes});
    notifyListeners();
  }

  /// Adds a comment to a post.
  /// Takes [userID] - ID of who's posting the comment (string),
  ///       [postOwnerID] - ID of the user who posted the post (string),
  ///       [postId] - ID of the post (string),
  ///       [comment] - Comment to be added (string).
  /// FireBaseFirestore instance is called to store the data back into DB.
  Future<void> addComment(
      String userID, String postOwnerID, String postId, String comment) async {
    await fireStoreInstance
        .collection("users")
        .doc(postOwnerID)
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .add({"ownerId": userID, "comment": comment});

    if (postOwnerID == userID) {
      return;
    }

    final user =
        await UserModel(userID: userID, fireBaseInstance: fireStoreInstance)
            .getUserInfo();

    final notification = MyNotification(
      type: 'commented',
      user: user,
      post: this,
      isNew: true,
      timestamp: Timestamp.now(),
    );

    await _notificationModel.addNotification(ownerId, notification);

    notifyListeners();
  }

  /// FirebaseFirestore instance is called to delete the post from DB.
  /// This function is called when the user deletes a post.
  /// This function is called from [individual_post_view.dart].
  Future<void> deletePost() async {
    fireStoreInstance
        .collection("users")
        .doc(ownerId)
        .collection("posts")
        .doc(postID)
        .collection("comments")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        document.reference.delete();
      });
    });

    fireStoreInstance
        .collection("users")
        .doc(ownerId)
        .collection("posts")
        .doc(postID)
        .delete();

    final notificationsQuerySnapshot = await fireStoreInstance
        .collection("users")
        .doc(ownerId)
        .collection("notifications")
        .where('post', isEqualTo: postID)
        .get();
    final notificationsDocs = notificationsQuerySnapshot.docs;
    for (final notificationDoc in notificationsDocs) {
      await notificationDoc.reference.delete();
    }
  }

  /// This method is to get the PostModel by using looking for the postId in DB.
  /// This function takes
  /// postId --- A string to represent the post's id.
  /// ownerId --- A string to represent the owner's id.
  /// fireStoreInstance -- The Database.
  static Future<PostModel> fetchPostById(String postId, String ownerId,
      FirebaseFirestore fireStoreInstance) async {
    final postDoc = await fireStoreInstance
        .collection('users')
        .doc(ownerId)
        .collection('posts')
        .doc(postId)
        .get();

    if (postDoc.data() == null) {
      return PostModel(
        caption: '',
        lat: 0,
        long: 0,
        likes: [],
        mediaUrl: 'www.test.com',
        ownerId: ownerId,
        postID: postId,
        timestamp: Timestamp.now(),
        fireStoreInstance: fireStoreInstance,
      );
    }

    return PostModel(
      caption: postDoc['caption'],
      lat: postDoc['latitude'],
      long: postDoc['longitude'],
      likes: postDoc['likes'],
      mediaUrl: postDoc['mediaUrl'],
      ownerId: postDoc['ownerId'],
      postID: postDoc['postId'],
      timestamp: postDoc['timestamp'],
      fireStoreInstance: fireStoreInstance,
    );
  }
}
