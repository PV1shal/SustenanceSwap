import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urban_sketchers/screens/login_page.dart';
import 'mock.dart';
import 'package:mock_exceptions/mock_exceptions.dart';

final userIdTokenResult = IdTokenResult({
  'authTimestamp': DateTime.now().millisecondsSinceEpoch,
  'claims': {'role': 'admin'},
  'token': 'some_long_token',
  'expirationTime':
      DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch,
  'issuedAtTimestamp':
      DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch,
  'signInProvider': 'phone',
});
void main() {
  late MockUser tUser;
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseStorageMocks();
  group('login page group test cases', () {
    setUpAll(() async {
      await Firebase.initializeApp();

      tUser = MockUser(
        isAnonymous: false,
        email: 'bob@thebuilder.com',
        displayName: 'Bob Builder',
        phoneNumber: '0800 I CAN FIX IT',
        photoURL: 'http://photos.url/bobbie.jpg',
        refreshToken: 'some_long_token',
        idTokenResult: userIdTokenResult,
      );
    });

    testWidgets('login page ...', (tester) async {
      var login = LoginPage();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: login,
          ),
        ),
      );
      await tester.pumpAndSettle();

      /// WITHOUT entring text in username and password, tap on sign in
      var signIn = find.text('Sign in');
      expect(signIn, findsOneWidget);
      await tester.tap(signIn);
    });

    testWidgets('click on register link', (tester) async {
      var login = LoginPage();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: login,
          ),
        ),
      );
      await tester.pumpAndSettle();

      var reg = find.byKey(const Key('register-link'));
      expect(reg, findsOneWidget);
      await tester.tap(reg);
    });

    testWidgets('enter email and click on submit', (tester) async {
      var login = LoginPage();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: login,
          ),
        ),
      );
      await tester.pumpAndSettle();
      login.setFirebaseAuth = MockFirebaseAuth();
      var emailField = find.byKey(const Key('sign-in-email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, 'a');
      var signIn = find.text('Sign in');
      expect(signIn, findsOneWidget);
      await tester.tap(signIn);
    });

    testWidgets('enter password only and click on submit', (tester) async {
      var login = LoginPage();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: login,
          ),
        ),
      );
      await tester.pumpAndSettle();
      login.setFirebaseAuth = MockFirebaseAuth();
      var passField = find.byKey(const Key('sign-in-password'));
      expect(passField, findsOneWidget);
      await tester.enterText(passField, 'a');
      var signIn = find.text('Sign in');
      expect(signIn, findsOneWidget);
      await tester.tap(signIn);
    });

    testWidgets('successful user', (tester) async {
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
    });

    testWidgets('enter password only and click on submit', (tester) async {
      var login = LoginPage();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: login,
          ),
        ),
      );
      await tester.pumpAndSettle();
      login.setFirebaseAuth = MockFirebaseAuth();
      var passField = find.byKey(const Key('sign-in-password'));
      expect(passField, findsOneWidget);
      await tester.enterText(passField, 'a');
      var signIn = find.text('Sign in');
      await tester.tap(signIn);
    });

    testWidgets('user not found error', (tester) async {
      final auth = MockFirebaseAuth();

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
      whenCalling(Invocation.method(#signInWithEmailAndPassword, null))
          .on(auth)
          .thenThrow(FirebaseAuthException(code: 'user-not-found'));
      const email = 'sme@test.com';
      const password = 'some!password';

      var emailField = find.byKey(const Key('sign-in-email'));
      await tester.enterText(emailField, email);

      var passField = find.byKey(const Key('sign-in-password'));
      await tester.enterText(passField, password);

      var signIn = find.text('Sign in');
      await tester.tap(signIn);
    });

    testWidgets('wrong-password error', (tester) async {
      final auth = MockFirebaseAuth();

      var loginPage = LoginPage();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: loginPage,
          ),
        ),
      );

      await tester.pumpAndSettle();
      loginPage.setFirebaseAuth = auth;
      whenCalling(Invocation.method(#signInWithEmailAndPassword, null))
          .on(auth)
          .thenThrow(FirebaseAuthException(code: 'wrong-password'));
      const email = 'sme@test.com';
      const password = 'some!password';

      var emailField = find.byKey(const Key('sign-in-email'));
      await tester.enterText(emailField, email);

      var passField = find.byKey(const Key('sign-in-password'));
      await tester.enterText(passField, password);

      var signIn = find.text('Sign in');
      await tester.tap(signIn);
    });
  });
}
