import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:urban_sketchers/screens/register_page.dart';
import 'upload_test.mocks.dart' as base_mock;
import 'mock.dart';

import 'register_page_test.mocks.dart';

/// security rules for fake firestore
final authUidDescription = '''
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}''';
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

/// mock image picker platform for pick image
class _MockImagePickerPlatform extends base_mock.MockImagePickerPlatform
    with MockPlatformInterfaceMixin {}

@GenerateMocks(<Type>[],
    customMocks: <MockSpec<dynamic>>[MockSpec<ImagePickerPlatform>()])
void main() {
  late MockUser tUser;
  late _MockImagePickerPlatform mockPlatform;
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseStorageMocks();
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
    mockPlatform = _MockImagePickerPlatform();
    ImagePickerPlatform.instance = mockPlatform;
  });

  testWidgets('register page first error alert', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegisterPage(),
        ),
      ),
    );

    var register = find.byKey(const Key('RegisterButton'));
    expect(register, findsOneWidget);

    var email = find.byKey(const Key('EmailEntryField'));
    expect(email, findsOneWidget);
    await tester.enterText(email, "bob@gmail.com");

    var password = find.byKey(const Key('PasswordEntryField'));
    expect(password, findsOneWidget);
    await tester.enterText(password, "123456789");

    var repassword = find.byKey(const Key('ConfPswdEntryField'));
    expect(repassword, findsOneWidget);
    await tester.enterText(
        repassword, "123456780"); //not same password in confirm password field

    await tester.tap(register);
    await tester.pump(); //'Password Error' dialog shown here

    var okBtn = find.byType(TextButton);
    await tester.tap(okBtn);
    await tester.pump();
  });

  testWidgets('register page but not matching passwords', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegisterPage(),
        ),
      ),
    );

    var register = find.byKey(const Key('RegisterButton'));
    expect(register, findsOneWidget);

    var email = find.byKey(const Key('EmailEntryField'));
    expect(email, findsOneWidget);
    await tester.enterText(email, "bob@gmail.com");

    var password = find.byKey(const Key('PasswordEntryField'));
    expect(password, findsOneWidget);
    await tester.enterText(password, "123456789");

    var repassword = find.byKey(const Key('ConfPswdEntryField'));
    expect(repassword, findsOneWidget);
    await tester.enterText(
        repassword, "123456780"); //not same password in confirm password field
    await tester
        .tap(register); //'Your Password Does Not Match!!!' snackbar shown here
    await tester.idle();
  });

  testWidgets('register page successfully without image', (tester) async {
    final auth = MockFirebaseAuth(mockUser: tUser);
    final firestore = FakeFirebaseFirestore(
        securityRules: authUidDescription,
        authObject: auth.authForFakeFirestore);
    var registerPage = RegisterPage();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: registerPage,
        ),
      ),
    );
    await tester.pumpAndSettle();
    registerPage.firebaseAuth = auth;
    registerPage.firebaseFirestore = firestore;

    var register = find.byKey(const Key('RegisterButton'));
    expect(register, findsOneWidget);

    var username = find.byKey(const Key('UsernameEntryField'));
    await tester.enterText(username, "bob");

    var name = find.byKey(const Key('FullnameEntryField'));
    await tester.enterText(name, "bob");

    var email = find.byKey(const Key('EmailEntryField'));
    expect(email, findsOneWidget);
    await tester.enterText(email, "bob@gmail.com");

    var password = find.byKey(const Key('PasswordEntryField'));
    expect(password, findsOneWidget);
    await tester.enterText(password, "123456789");

    var repassword = find.byKey(const Key('ConfPswdEntryField'));
    expect(repassword, findsOneWidget);
    await tester.enterText(
        repassword, "123456789"); //same password in confirm password field now
    await tester.tap(
        register); //'Registration success!Please Log In' snackbar shown here
    await tester.pump();
  });

  testWidgets('register page successfully with image', (tester) async {
    when(mockPlatform.getImageFromSource(
            source: anyNamed('source'), options: anyNamed('options')))
        .thenAnswer((Invocation _) async =>
            Future.value(XFile('assets/images/defaultUser.png')));
    final auth = MockFirebaseAuth(mockUser: tUser);
    final firestore = FakeFirebaseFirestore(
        securityRules: authUidDescription,
        authObject: auth.authForFakeFirestore);
    var registerPage = RegisterPage();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: registerPage,
        ),
      ),
    );
    await tester.pumpAndSettle();
    registerPage.firebaseAuth = auth;
    registerPage.firebaseFirestore = firestore;

    var cameraIcon = find.byIcon(Icons.camera_alt);
    expect(cameraIcon, findsOneWidget);
    await tester.tap(cameraIcon);
    await tester.pump();

    var register = find.byKey(const Key('RegisterButton'));
    expect(register, findsOneWidget);

    var username = find.byKey(const Key('UsernameEntryField'));
    await tester.enterText(username, "bob");

    var name = find.byKey(const Key('FullnameEntryField'));
    await tester.enterText(name, "bob");

    var email = find.byKey(const Key('EmailEntryField'));
    expect(email, findsOneWidget);
    await tester.enterText(email, "bob@gmail.com");

    var password = find.byKey(const Key('PasswordEntryField'));
    expect(password, findsOneWidget);
    await tester.enterText(password, "123456789");

    var repassword = find.byKey(const Key('ConfPswdEntryField'));
    expect(repassword, findsOneWidget);
    await tester.enterText(
        repassword, "123456789"); //same password in confirm password field now
    await tester.tap(
        register); //'Registration success!Please Log In' snackbar shown here
    await tester.pump();
  });
  // testWidgets('register page to login link', (tester) async {
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: Scaffold(
  //         body: RegisterPage(),
  //       ),
  //     ),
  //   );

  //   var login = find.byKey(const Key('LinktoSignInPage'));
  //   expect(login, findsOneWidget);

  //   await tester.tap(login);
  //   await tester.pump();
  // });
}
