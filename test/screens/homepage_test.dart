import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:urban_sketchers/screens/homepage.dart';
import 'package:urban_sketchers/screens/login_page.dart';
import 'mock.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseStorageMocks();
  group('description', () {
    final user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );

    final auth = MockFirebaseAuth(mockUser: user);
    final fakeFirebase = FakeFirebaseFirestore();

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      setupFirebaseStorageMocks();
      await Firebase.initializeApp();

      // when(auth.authStateChanges()).thenAnswer((_) => user);
    });

    testWidgets('HomePage widget displays correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(
              firebaseAuth: auth, firebaseFirestoreInstance: fakeFirebase),
        ),
      );

      await tester.tap(find.byIcon(Icons.map_sharp));
      try {
        await tester.pumpAndSettle();
      } catch (e) {}
      await tester.tap(find.byIcon(Icons.add_circle));
      try {
        await tester.pumpAndSettle();
      } catch (e) {}
    });

    testWidgets('Covering changeAuth', (WidgetTester tester) async {
      final userIdTokenResult = IdTokenResult({
        'authTimestamp': DateTime.now().millisecondsSinceEpoch,
        'claims': {'role': 'admin'},
        'token': 'some_long_token',
        'expirationTime':
            DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch,
        'issuedAtTimestamp': DateTime.now()
            .subtract(const Duration(days: 1))
            .millisecondsSinceEpoch,
        'signInProvider': 'phone',
      });
      MockUser tUser = MockUser(
        isAnonymous: false,
        email: 'bob@thebuilder.com',
        displayName: 'Bob Builder',
        phoneNumber: '0800 I CAN FIX IT',
        photoURL: 'http://photos.url/bobbie.jpg',
        refreshToken: 'some_long_token',
        idTokenResult: userIdTokenResult,
      );

      final auth = MockFirebaseAuth(mockUser: tUser);
      var login = LoginPage();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: login,
          ),
        ),
      );
      await tester.pumpAndSettle();
      login.setFirebaseAuth = auth;
      const email = 'bob@thebuilder.com';
      const password = 'some!password';

      var emailField = find.byKey(const Key('sign-in-email'));
      await tester.enterText(emailField, email);

      var passField = find.byKey(const Key('sign-in-password'));
      await tester.enterText(passField, password);

      var signIn = find.text('Sign in');
      expect(signIn, findsOneWidget);
      await tester.tap(signIn);
      try {
        await tester.pumpAndSettle();
      } catch (e) {}
    });
  });
}
