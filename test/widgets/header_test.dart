import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urban_sketchers/widgets/header.dart';

void main() {
  testWidgets('header widget testing', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(appBar: header(titleText: "Test app")),
    ));
    expect(find.text("Test app"), findsOneWidget);
  });
}
