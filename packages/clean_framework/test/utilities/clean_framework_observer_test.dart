import 'package:clean_framework/clean_framework.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Clean Framework Observer tests |', () {
    test('location update is reflected in observer', () {
      CleanFrameworkObserver.instance.onLocationChanged('/profile');

      CleanFrameworkObserver.instance = TestObserver();

      expect(
        (CleanFrameworkObserver.instance as TestObserver).location,
        isEmpty,
      );

      CleanFrameworkObserver.instance.onLocationChanged('/profile');

      expect(
        (CleanFrameworkObserver.instance as TestObserver).location,
        equals('/profile'),
      );
    });
  });
}

class TestObserver extends CleanFrameworkObserver {
  String location = '';

  @override
  void onLocationChanged(String location) {
    this.location = location;
  }
}
