import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_example/features.dart';
import 'package:clean_framework_example/main.dart' as app;

void main() {
  test('Load providers', () {
    loadProviders();
    final fb = firebaseExternalInterface.getExternalInterface(providersContext);
    expect(fb, isA<FirebaseExternalInterface>());
  });
  testWidgets('Main app', (tester) async {
    final featureTester = FeatureTester(featureStatesProvider);
    await featureTester.pumpWidget(
      tester,
      app.ExampleApp(),
    );
    await tester.pumpAndSettle();
    expect(find.byType(app.ExampleApp), findsOneWidget);
    expect(featureTester.featuresMap.defaultState, isA<FeatureState>);
  });
}
