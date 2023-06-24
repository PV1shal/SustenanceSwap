import 'package:flutter_test/flutter_test.dart';
import 'package:urban_sketchers/utils/image_utils.dart';
import 'dart:io';

void main() {
  group('compressImage function', () {
    test('returns compressed image file', () async {
      final image = File('assets/images/defaultUser.png');
      const fileName = 'test_image.jpg';

      final compressedImage = await compressImage(fileName, image);

      expect(compressedImage.existsSync(), true);
      expect(compressedImage.lengthSync() < image.lengthSync(), true);
    });
  });
}
