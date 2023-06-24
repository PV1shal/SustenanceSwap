import 'package:flutter_test/flutter_test.dart';
import 'package:urban_sketchers/firebase_options.dart';
import 'package:flutter/foundation.dart'
    show
        TargetPlatform,
        debugDefaultTargetPlatformOverride,
        defaultTargetPlatform;

void main() {
  group("firebase options testing", () {
    test('DefaultFirebaseOptions.currentPlatform as IOS', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final currentOptions = DefaultFirebaseOptions.currentPlatform;
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        expect(currentOptions, equals(DefaultFirebaseOptions.ios));
      } else {
        expect(() => DefaultFirebaseOptions.currentPlatform,
            throwsA(isInstanceOf<UnsupportedError>()));
      }
      debugDefaultTargetPlatformOverride = null;
    });
    test('DefaultFirebaseOptions.currentPlatform as ANDROID', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final currentOptions = DefaultFirebaseOptions.currentPlatform;
      if (defaultTargetPlatform == TargetPlatform.android) {
        expect(currentOptions, equals(DefaultFirebaseOptions.android));
      } else {
        expect(() => DefaultFirebaseOptions.currentPlatform,
            throwsA(isInstanceOf<UnsupportedError>()));
      }
      debugDefaultTargetPlatformOverride = null;
    });

    test('DefaultFirebaseOptions.currentPlatform as macOS', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      final currentOptions = DefaultFirebaseOptions.currentPlatform;
      if (defaultTargetPlatform == TargetPlatform.macOS) {
        expect(currentOptions, equals(DefaultFirebaseOptions.macos));
      } else {
        expect(() => DefaultFirebaseOptions.currentPlatform,
            throwsA(isInstanceOf<UnsupportedError>()));
      }
      debugDefaultTargetPlatformOverride = null;
    });

    test('DefaultFirebaseOptions.currentPlatform as windows', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      final currentOptions = TargetPlatform.windows;
      if (defaultTargetPlatform == TargetPlatform.windows) {
        expect(() => DefaultFirebaseOptions.currentPlatform,
            throwsA(isInstanceOf<UnsupportedError>()));
      }
      debugDefaultTargetPlatformOverride = null;
    });

    test('DefaultFirebaseOptions.currentPlatform as linux', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      final currentOptions = TargetPlatform.linux;
      if (defaultTargetPlatform == TargetPlatform.linux) {
        expect(() => DefaultFirebaseOptions.currentPlatform,
            throwsA(isInstanceOf<UnsupportedError>()));
      }
      debugDefaultTargetPlatformOverride = null;
    });

    test('DefaultFirebaseOptions.currentPlatform as fuchsia', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
      final currentOptions = TargetPlatform.fuchsia;
      if (defaultTargetPlatform == TargetPlatform.fuchsia) {
        expect(() => DefaultFirebaseOptions.currentPlatform,
            throwsA(isInstanceOf<UnsupportedError>()));
      }
      debugDefaultTargetPlatformOverride = null;
    });
  });
}
