import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_framework_example/main.dart' as app;

void main() {
  test('Load providers', () {
    loadProviders();
    final fb = firebaseExternalInterface.getExternalInterface(providersContext);
    expect(fb, isA<FirebaseExternalInterface>());
  });
  testWidgets('Main app', (tester) async {
    await
  });
}
