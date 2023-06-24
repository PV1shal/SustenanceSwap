import 'package:flutter_test/flutter_test.dart';
import 'package:urban_sketchers/utils/privacy_option.dart';

void main() {
  test('privacy option', () {
    expect("Only me", PrivacyOption.onlyMe.value);
    expect("Public", PrivacyOption.public.value);
  });
}
