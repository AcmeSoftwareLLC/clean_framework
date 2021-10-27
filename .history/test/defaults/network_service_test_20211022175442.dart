import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('RestMethod', () {
    expect(RestMethod.get.rawString, 'GET');
  });
}
