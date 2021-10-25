import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/src/feature_state/feature_state_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FeatureTester<S> {
  final context = ProvidersContext();
  final FeatureStateProvider _featureStateProvider;

  FeatureTester(this._featureStateProvider);

  Future<void> pumpWidget(WidgetTester tester, Widget widget) =>
      tester.pumpWidget(
          UncontrolledProviderScope(container: context(), child: widget));

  void dispose() => context.dispose();

  FeatureMapper<S> get featuresMap =>
      context().read(_featureStateProvider.featuresMap);
}
