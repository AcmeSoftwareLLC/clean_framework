import 'package:clean_framework/clean_framework_defaults.dart'
    hide FeatureState;
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_example/features.dart';
import 'package:clean_framework_example/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('main', () {
    expect(() => app.main(), throwsAssertionError);
  });
  test('Load providers', () {
    loadProviders();
    final fb = firebaseExternalInterface.getExternalInterface(providersContext);
    expect(fb, isA<FirebaseExternalInterface>());
  });
  testWidgets('Main app', (tester) async {
    await tester.pumpWidget(
      app.ExampleApp(),
    );
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Uncomment this to see the widget tree on the console
    // debugDumpApp();

    expect(find.byType(app.ExampleApp), findsOneWidget);

    final featuresMap =
        providersContext().read(featureStatesProvider.featuresMap);

    expect(featuresMap.defaultState, isA<FeatureState>());
    expect(featuresMap.getStateFor(lastLoginFeature), FeatureState.hidden);
  });
}
