import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:urban_sketchers/widgets/widgets.dart';

void main() {
  testWidgets('Returns Asset', (tester) async {
    await mockNetworkImagesFor(
      () => tester.pumpWidget(MaterialApp(
        home: circularProfilePic("uri", 50),
      )),
    );
  });
}
