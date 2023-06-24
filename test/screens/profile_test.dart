import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import 'package:urban_sketchers/models/post.dart';
import 'package:urban_sketchers/models/user.dart';
import 'package:mockito/mockito.dart';
import 'package:urban_sketchers/screens/Profile/edit_user.dart';
import 'package:urban_sketchers/screens/Profile/profile.dart';
import 'package:http/http.dart' as http;
import 'package:urban_sketchers/screens/Profile/share_profile.dart';
import 'package:urban_sketchers/screens/Profile/signout_modal.dart';
import 'package:urban_sketchers/screens/Profile/terms_and_conditions.dart';
import 'package:urban_sketchers/screens/screens.dart';
import 'dart:async';

void main() {
  group('Profile Testing', () {
    QuerySnapshot<Map<String, dynamic>> snapshot;
    late UserModel user;
    final instance = FakeFirebaseFirestore();
    instance.collection('users').doc("test").set({
      'Username': 'Bob',
      'Full name': 'tester bob',
      'bio': 'This is a Bio',
      'Profile Pic': null
    });
    instance.collection('users').doc("test").collection('posts').add({
      "caption": "",
      "latitude": 0.0,
      "longitude": 0.0,
      "likes": [],
      "mediaUrl": "www.test.com",
      "ownerId": "test",
      "postId": "1",
      "timestamp": Timestamp.fromDate(DateTime(2022))
    });

    setUpAll(() async => {
          snapshot = await instance.collection('users').get(),
          user = UserModel(
              userID: snapshot.docs.first.id, fireBaseInstance: instance),
          user.getUserInfo(),
        });

    testWidgets('Share button check', (WidgetTester tester) async {
      PostModel posts =
          user.posts[0]; //Added just for the sake of 100% coverage
      await mockNetworkImagesFor(
        () => tester.pumpWidget(ChangeNotifierProvider.value(
          value: user,
          child: MaterialApp(home: ProfilePage()),
        )),
      );

      await tester.tap(find.byKey(const Key('Share Button')));
      await tester.pump();
    });

    testWidgets('Help option more settings check', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await mockNetworkImagesFor(
        () => tester.pumpWidget(ChangeNotifierProvider.value(
          value: user,
          child: MaterialApp(home: ProfilePage()),
        )),
      );

      await tester.tap(find.byKey(const Key("Settings Button")));
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));

      await tester.tap(find.widgetWithText(TextButton, "Help"));
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('Privacy Policy Check', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await mockNetworkImagesFor(
        () => tester.pumpWidget(ChangeNotifierProvider.value(
          value: user,
          child: MaterialApp(home: ProfilePage()),
        )),
      );

      await tester.tap(find.byKey(const Key("Settings Button")));
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      // await expectLater(tester, meetsGuideline(textContrastGuideline));

      await tester.tap(find.widgetWithText(TextButton, "About Us"));
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      // await expectLater(tester, meetsGuideline(textContrastGuideline));

      // Scroll down to bring the "Privacy Policy" button into view
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      // await expectLater(tester, meetsGuideline(textContrastGuideline));

      // Tap the "Privacy Policy" button
      await tester.tap(find.byKey(Key("Privacy Policy")));
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      // await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });

    testWidgets('Terms and conditions Check', (WidgetTester tester) async {
      await mockNetworkImagesFor(
        () => tester.pumpWidget(ChangeNotifierProvider.value(
          value: user,
          child: MaterialApp(home: ProfilePage()),
        )),
      );

      await tester.tap(find.byKey(const Key("Settings Button")));
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));
      await tester.tap(find.widgetWithText(TextButton, "About Us"));
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      // Scroll down to bring the "Privacy Policy" button into view
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();

      // Tap the "Privacy Policy" button
      await tester.tap(find.byKey(Key("Terms & Conditions")));
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));
    });

    testWidgets('About Us option more settings check',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(
        () => tester.pumpWidget(ChangeNotifierProvider.value(
          value: user,
          child: MaterialApp(home: ProfilePage()),
        )),
      );

      await tester.tap(find.byKey(const Key("Settings Button")));
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));
      await tester.tap(find.widgetWithText(TextButton, "About Us"));
    });

    testWidgets('More Options check', (WidgetTester tester) async {
      await mockNetworkImagesFor(
        () => tester.pumpWidget(ChangeNotifierProvider.value(
          value: user,
          child: MaterialApp(home: ProfilePage()),
        )),
      );

      await tester.tap(find.byKey(const Key("Settings Button")));
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));
      await tester.tap(find.widgetWithIcon(IconButton, Icons.close));
    });

    testWidgets('Edit Profile button check', (WidgetTester tester) async {
      await mockNetworkImagesFor(
        () => tester.pumpWidget(ChangeNotifierProvider.value(
          value: user,
          child: MaterialApp(home: ProfilePage()),
        )),
      );

      await tester.tap(find.byKey(const Key("Edit Button")));
      await tester.pump();
    });

    testWidgets('Click to expand Bio', (WidgetTester tester) async {
      await mockNetworkImagesFor(
        () => tester.pumpWidget(ChangeNotifierProvider.value(
          value: user,
          child: MaterialApp(home: ProfilePage()),
        )),
      );

      await tester.tap(find.byKey(const Key("Bio Expand")));
      await tester.pump();
    });

    testWidgets('Save changes button - Edit Profile',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(
        () => tester.pumpWidget(ChangeNotifierProvider.value(
          value: user,
          child: MaterialApp(home: EditUser()),
        )),
      );
      await tester.tap(find.widgetWithIcon(GestureDetector, Icons.done),
          warnIfMissed: false);
      await tester.tap(find.bySemanticsLabel("Tap to edit Profile Pic"),
          warnIfMissed: false);
    });
  });

  group('Share Profile', () {
    testWidgets('Share button in share profile page check',
        (WidgetTester tester) async {
      String uid = "test";
      String userName = "bob";
      ShareProfile sp = ShareProfile(userID: uid, userName: userName);
      await tester.pumpWidget(MaterialApp(
        home: sp,
      ));
      await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.copy),
          warnIfMissed: false);
    });
  });

  group('signOutDialog', () {
    testWidgets('Opening and closing dialogue', (WidgetTester tester) async {
      // Create a mock FirebaseAuth instance
      final auth = MockFirebaseAuth();
      // Define a function to build the context
      BuildContext buildContext() {
        return tester.element(find.text('Sign out'));
      }

      // Build the widget tree with MaterialApp
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: ElevatedButton(
              onPressed: () => signOutDialog(buildContext(), auth),
              child: const Text('Sign out'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('No'));
    });
    testWidgets('clicking on signout', (WidgetTester tester) async {
      // Create a mock FirebaseAuth instance
      final auth = MockFirebaseAuth();
      // Define a function to build the context
      BuildContext buildContext() {
        return tester.element(find.text('Sign out'));
      }

      // Build the widget tree with MaterialApp
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: ElevatedButton(
              onPressed: () => signOutDialog(buildContext(), auth),
              child: const Text('Sign out'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Yes'));
    });
  });
}
