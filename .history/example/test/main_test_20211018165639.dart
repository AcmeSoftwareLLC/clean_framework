import 'package:clean_framework/clean_framework_defaults.dart'
    hide FeatureState;
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_example/features.dart';
import 'package:clean_framework_example/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';

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
      app.ExampleApp(providersContext: featureTester.context),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byType(app.ExampleApp), findsOneWidget);
    expect(featureTester.featuresMap.defaultState, isA<FeatureState>());
    expect(featureTester.featuresMap.getStateFor(lastLoginFeature),
        FeatureState.active);
  });
}
