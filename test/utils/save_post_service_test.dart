import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:urban_sketchers/utils/save_post_service.dart';

// https://firebase.google.com/docs/rules/rules-and-auth#leverage_user_information_in_rules
final authUidDescription = '''
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}''';
void main() {
  test('save post', () async {
    final auth = MockFirebaseAuth();
    final firestore = FakeFirebaseFirestore(
        // Pass security rules to restrict `/users/{user}` documents.
        securityRules: authUidDescription,
        // Make MockFirebaseAuth inform FakeFirebaseFirestore of sign-in
        // changes.
        authObject: auth.authForFakeFirestore);

    await auth.signInWithCustomToken('some token');
    final user = auth.currentUser;
    var save = SaveInFirestore(user!, firestore);
    expect(
        () => save.putPostInFirestore(
            mediaUrl: "foo/bar",
            latitude: 0,
            longitude: 0,
            privacyOption: "public",
            postId: "1"),
        returnsNormally);
  });
}
