import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urban_sketchers/main.dart' as mainFile;

void main() {
  testWidgets('main widget testing', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: mainFile.MyApp()));
  });
}
