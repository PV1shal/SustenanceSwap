import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urban_sketchers/widgets/text_entry_box.dart';

void main() {
  testWidgets('text entry box ...', (tester) async {
    await tester.pumpWidget(textEntryBox());
    expect(find.byType(Container), findsOneWidget);
  });
}
