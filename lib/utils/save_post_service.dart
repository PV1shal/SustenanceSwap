import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// save post data in firestore
class SaveInFirestore {
  /// instance of current user
  final User currentUser;

  /// instance of FirebaseFirestore
  final FirebaseFirestore firestore;

  /// constructor of SaveInFirestore
  SaveInFirestore(this.currentUser, this.firestore);

  /// function to save post in firestore
  Future<void> putPostInFirestore({
    required String mediaUrl,
    required double latitude,
    required double longitude,
    required String privacyOption,
    required String postId,
    String? caption,
  }) async {
    final userUid = currentUser.uid;

    final postRef = firestore
        .collection('users')
        .doc(userUid)
        .collection('posts')
        .doc(postId);

    final batch = firestore.batch();

    batch.set(postRef, {
      'postId': postId,
      'ownerId': userUid,
      'mediaUrl': mediaUrl,
      'caption': caption,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': DateTime.now(),
      'privacy': privacyOption,
      'likes': [],
    });

    await batch.commit();
  }
}
