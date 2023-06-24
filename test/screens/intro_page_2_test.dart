import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urban_sketchers/screens/Intros/intro_page_2.dart';
import 'package:urban_sketchers/utils/app_colors.dart';

void main() {
  group('IntroTwo widget', () {
    testWidgets('Test image 1 position and size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.ltr,
            child: IntroTwo(),
          ),
        ),
      );
      final imageFinder = find.byWidgetPredicate((widget) =>
          widget is Image &&
          widget.image.toString().contains('welcome_eclipse2.png'));
      expect(imageFinder, findsOneWidget);
      final Positioned positionedWidget = tester.widget<Positioned>(find
          .ancestor(of: imageFinder, matching: find.byType(Positioned))
          .first);
      expect(positionedWidget.top, equals(216));
      expect(positionedWidget.height, equals(250));
    });

    testWidgets('Test image 1 fit', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.ltr,
            child: IntroTwo(),
          ),
        ),
      );
      final imageFinder = find.byWidgetPredicate((widget) =>
          widget is Image &&
          widget.image.toString().contains('welcome_eclipse2.png'));
      expect(imageFinder, findsOneWidget);
      final Image imageWidget = tester.widget<Image>(imageFinder);
      expect(imageWidget.fit, equals(BoxFit.cover));
    });

    testWidgets('Test image 2 position and size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.ltr,
            child: IntroTwo(),
          ),
        ),
      );
      final imageFinder = find.byWidgetPredicate((widget) =>
          widget is Image &&
          widget.image.toString().contains('artist_icon.png'));
      expect(imageFinder, findsOneWidget);
      final Positioned positionedWidget = tester.widget<Positioned>(find
          .ancestor(of: imageFinder, matching: find.byType(Positioned))
          .first);
      expect(positionedWidget.top, equals(265));
      expect(positionedWidget.left, equals(126));
      expect(positionedWidget.height, equals(150));
    });

    testWidgets('Test image 2 fit', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.ltr,
            child: IntroTwo(),
          ),
        ),
      );
      final imageFinder = find.byWidgetPredicate((widget) =>
          widget is Image &&
          widget.image.toString().contains('artist_icon.png'));
      expect(imageFinder, findsOneWidget);
      final Image imageWidget = tester.widget<Image>(imageFinder);
      expect(imageWidget.fit, equals(BoxFit.cover));
    });

    testWidgets('Test tagline text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.ltr,
            child: IntroTwo(),
          ),
        ),
      );
      final taglineFinder = find.text('Discover Local Artists');
      expect(taglineFinder, findsOneWidget);
      final Text taglineText = tester.widget<Text>(taglineFinder);
      expect(taglineText.style!.fontSize, equals(24.0));
      expect(taglineText.style!.fontFamily, equals('Source Sans Pro'));
      expect(taglineText.style!.color, equals(AppColors.primaryFocusColor));
      expect(taglineText.style!.fontWeight, equals(FontWeight.bold));
      expect(taglineText.style!.fontStyle, equals(FontStyle.italic));
    });

    testWidgets('Test tagline2 text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.ltr,
            child: IntroTwo(),
          ),
        ),
      );
      final taglineFinder =
          find.text('Find the best artist nearby & make commissions');
      expect(taglineFinder, findsOneWidget);
      final Text taglineText = tester.widget<Text>(taglineFinder);
      expect(taglineText.style!.fontSize, equals(16.0));
      expect(taglineText.style!.fontFamily, equals('Source Sans Pro'));
      expect(taglineText.style!.color, equals(AppColors.iconColor));
    });
  });
}
