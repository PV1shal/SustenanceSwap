import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urban_sketchers/models/post.dart';

/// User model used to store user data retrieved from Firestore.
class UserModel extends ChangeNotifier {
  /// User's uid/
  String userID;

  /// User's username.
  String username = "";

  /// USers' fullname.
  String fullName = "";

  /// User's Bio.
  String bio = "";

  /// User's Profile Pic - Firebase URL.
  String? profilePic;

  /// List of Posts the user has uploaded.
  List<PostModel> posts = [];

  final fireBaseInstance;

  /// Initalises all the user's data.
  /// Adds listener this details so the data is updated something is updated in the DB.
  UserModel({required this.userID, required this.fireBaseInstance}) {
    fireBaseInstance
        .collection('users')
        .doc(userID)
        .snapshots()
        .listen((userDoc) {
      if (userDoc.exists) {
        username = userDoc.get('Username');
        fullName = userDoc.get('Full name');
        bio = userDoc.get('bio');
        profilePic = userDoc.get('Profile Pic');
        notifyListeners();
      }
    });
    fireBaseInstance
        .collection('users')
        .doc(userID)
        .collection('posts')
        .snapshots()
        .listen((querySnapshot) {
      posts.clear();
      querySnapshot.docs.forEach((doc) {
        // print(doc.get(''));
        posts.add(PostModel(
          caption: doc.get('caption'),
          // comments: doc.get('comments'),
          lat: doc.get('latitude'),
          long: doc.get('longitude'),
          likes: doc.get('likes'),
          mediaUrl: doc.get('mediaUrl'),
          ownerId: doc.get('ownerId'),
          postID: doc.get('postId'),
          timestamp: doc.get('timestamp'),
          fireStoreInstance: fireBaseInstance,
        ));
      });
      notifyListeners();
    });
  }

  /// Gets the user's data from the DB.
  Future<UserModel> getUserInfo() async {
    final userDoc =
        await fireBaseInstance.collection('users').doc(userID).get();

    if (userDoc.exists) {
      username = userDoc.get('Username');
      fullName = userDoc.get('Full name');
      bio = userDoc.get('bio');
      profilePic = userDoc.get('Profile Pic');
    }

    await fireBaseInstance
        .collection('users')
        .doc(userID)
        .collection('posts')
        .get()
        .then((querySnapshot) => {
              posts.clear(),
              querySnapshot.docs.forEach((doc) {
                // print("${doc.id} => ${doc.data()}");
                posts.add(PostModel(
                    caption: doc.get('caption'),
                    // comments: doc.get('comments'),
                    lat: doc.get('latitude'),
                    long: doc.get('longitude'),
                    likes: doc.get('likes'),
                    mediaUrl: doc.get('mediaUrl'),
                    ownerId: doc.get('ownerId'),
                    postID: doc.get('postId'),
                    timestamp: doc.get('timestamp'),
                    fireStoreInstance: fireBaseInstance));
              })
            });
    notifyListeners();

    return this;
  }

  /// Setters to set user's username.
  /// Takes [username] - new Username (String).
  set setUserName(String username) {
    this.username = username;
    fireBaseInstance
        .collection('users')
        .doc(userID)
        .update({"Username": username});
    // notifyListeners();
  }

  /// Setters to set user's fullname.
  /// Takes [fullname] - new Full name (String).
  set setFullName(String fullName) {
    this.fullName = fullName;
    fireBaseInstance
        .collection('users')
        .doc(userID)
        .update({"Full name": fullName});
    // notifyListeners();
  }

  /// Setters to set user's bio.
  /// Takes [bio] - new Bio (String).
  set setBio(String bio) {
    this.bio = bio;
    fireBaseInstance.collection('users').doc(userID).update({"bio": bio});
    // notifyListeners();
  }

  /// Setters to set user's profile Pic.
  /// Takes [uri] - new profile picture's firestore uri link (String).
  set setProfilePic(String uri) {
    profilePic = uri;
    fireBaseInstance
        .collection('users')
        .doc(userID)
        .update({"Profile Pic": uri});
    // notifyListeners();
  }
}
