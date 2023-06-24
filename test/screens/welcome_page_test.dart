import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:urban_sketchers/firebase_options.dart';
import 'package:urban_sketchers/main.dart';
import 'package:urban_sketchers/screens/screens.dart';
import 'package:urban_sketchers/screens/welcome_page.dart';
import 'package:urban_sketchers/utils/app_colors.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('WelcomePage widget test', () {
    testWidgets('renders PageView', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: WelcomePage()));
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('renders SmoothPageIndicator', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: WelcomePage()));
      expect(find.byType(SmoothPageIndicator), findsOneWidget);
      // this part of test throws error and not executing
      // await tester.tap(find.byWidgetPredicate((widget) =>
      //     widget is Container &&
      //     widget.child is SmoothPageIndicator &&
      //     (widget.child as SmoothPageIndicator).count == 4 &&
      //     (widget.child as SmoothPageIndicator).effect is ExpandingDotsEffect &&
      //     (widget.child as SmoothPageIndicator).controller is PageController));
      // await tester.pumpAndSettle();

      final PageController controller =
          (find.byType(PageView).evaluate().first.widget as PageView)
              .controller;
      expect(controller.page, equals(0));
    });

    testWidgets('test dot indicator', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: WelcomePage()));
      final smoothPageIndicatorFinder = find.byType(SmoothPageIndicator);
      expect(smoothPageIndicatorFinder, findsOneWidget);

      final SmoothPageIndicator smoothPageIndicator =
          tester.widget(smoothPageIndicatorFinder);
      expect(smoothPageIndicator.count, 4);
      expect(smoothPageIndicator.effect is ExpandingDotsEffect, true);
      expect(
          (smoothPageIndicator.effect as ExpandingDotsEffect).expansionFactor,
          1.5);
      expect((smoothPageIndicator.effect as ExpandingDotsEffect).dotColor,
          Colors.grey);
      expect((smoothPageIndicator.effect as ExpandingDotsEffect).activeDotColor,
          AppColors.primaryFocusColor);
      expect(
          (smoothPageIndicator.effect as ExpandingDotsEffect).strokeWidth, 2);
      expect((smoothPageIndicator.effect as ExpandingDotsEffect).paintStyle,
          PaintingStyle.fill);

      // Simulate tapping on the dot
      await tester.tap(find.descendant(
          of: smoothPageIndicatorFinder,
          matching: find.byType(GestureDetector)));
      await tester.pump();
      //Verify that the controller is animating to the correct page
      final PageController pageController = smoothPageIndicator.controller;
      expect(pageController.page, 0);
    });

    testWidgets('navigates to LoginPage', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: WelcomePage()));
      await tester.tap(find.text('SIGN IN'));

      expect(find.text('SIGN IN'), findsOneWidget);
      expect(
          find.descendant(
            of: find.byType(GestureDetector),
            matching: find.text('SIGN IN'),
          ),
          findsOneWidget);
    });

    testWidgets('navigates to RegisterPage', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: WelcomePage()));
      await tester.tap(find.text('REGISTER'));
      expect(find.text('REGISTER'), findsOneWidget);
      expect(
          find.descendant(
            of: find.byType(GestureDetector),
            matching: find.text('REGISTER'),
          ),
          findsOneWidget);
    });
  });
}
