import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urban_sketchers/widgets/widgets.dart';

void main() {
  testWidgets('circular progress testing', (tester) async {
    await tester.pumpWidget(customCircularProgressIndicator());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('linear progress testing', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      appBar: header(),
      body: customLinearProgressIndicator(),
    )));
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });
}
