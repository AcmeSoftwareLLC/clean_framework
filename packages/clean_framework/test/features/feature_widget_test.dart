import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/src/feature_state/feature.dart';
import 'package:clean_framework/src/feature_state/feature_mapper.dart';
import 'package:clean_framework/src/feature_state/feature_state_provider.dart';
import 'package:clean_framework/src/feature_state/feature_widget.dart';
import 'package:clean_framework/src/tests/feature_tester.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'FeatureStatesProvider hidden, then visible with load, then hide again',
      (tester) async {
    final featureStateProvider =
        FeatureStateProvider<FeatureState, TestFeatureStateMapper>(
      (_) => TestFeatureStateMapper(),
    );

    final featureTester = FeatureTester<FeatureState>(featureStateProvider);

    final testWidget = MaterialApp(
      home: Column(
        children: [
          TestFeatureWidget(
            featureStateProvider,
          ),
          ElevatedButton(
            key: const Key('loadButton'),
            child: const Text('load'),
            onPressed: () {
              featureTester.featuresMap.append({
                'features': [
                  {'name': 'login', 'version': '1.0', 'state': 'VISIBLE'},
                ]
              });
            },
          ),
          ElevatedButton(
            key: const Key('hideButton'),
            child: const Text('hide'),
            onPressed: () {
              featureTester.featuresMap.append({
                'features': [
                  {'name': 'login', 'version': '1.0', 'state': 'HIDDEN'},
                ]
              });
            },
          )
        ],
      ),
    );

    await featureTester.pumpWidget(tester, testWidget);

    expect(find.byType(TestFeatureWidget), findsOneWidget);
    expect(find.text('visible'), findsNothing);
    expect(find.byKey(const Key('empty')), findsOneWidget);

    await tester.tap(find.byKey(const Key('loadButton')));
    await tester.pumpAndSettle();

    expect(find.text('visible'), findsOneWidget);
    expect(find.byKey(const Key('empty')), findsNothing);

    await tester.tap(find.byKey(const Key('hideButton')));
    await tester.pump();

    expect(find.text('visible'), findsNothing);
    expect(find.byKey(const Key('empty')), findsOneWidget);

    featureTester.dispose();
  });

  testWidgets('FeatureStatesProvider load error', (tester) async {
    final featureStateProvider =
        FeatureStateProvider<FeatureState, TestFeatureStateMapper>(
      (_) => TestFeatureStateMapper(),
    );

    final featureTester = FeatureTester<FeatureState>(featureStateProvider);

    final testWidget = MaterialApp(
      home: Column(
        children: [
          TestFeatureWidget(
            featureStateProvider,
          ),
          ElevatedButton(
            key: const Key('loadButton'),
            child: const Text('load'),
            onPressed: () {
              try {
                featureTester.featuresMap.append({});
              } catch (e) {
                // no-op
              }
            },
          ),
        ],
      ),
    );

    await featureTester.pumpWidget(tester, testWidget);

    expect(find.byType(TestFeatureWidget), findsOneWidget);
    expect(find.text('visible'), findsNothing);
    expect(find.byKey(const Key('empty')), findsOneWidget);

    await tester.tap(find.byKey(const Key('loadButton')));
    await tester.pumpAndSettle();

    expect(find.text('visible'), findsNothing);
    expect(find.byKey(const Key('empty')), findsOneWidget);

    featureTester.dispose();
  });
}

class TestFeatureWidget extends FeatureWidget<FeatureState> {
  const TestFeatureWidget(
    FeatureStateProvider<FeatureState, FeatureMapper<FeatureState>> provider, {
    super.key,
  }) : super(
          feature: const Feature(name: 'login'),
          provider: provider,
        );

  @override
  Widget builder(BuildContext context, FeatureState currentState) {
    switch (currentState) {
      case FeatureState.visible:
        return const Text('visible');
      case FeatureState.hidden:
        return Container(key: const Key('empty'));
    }
  }
}

class TestFeatureStateMapper extends FeatureMapper<FeatureState> {
  static const Map<String, FeatureState> _jsonStateToFeatureStateMap = {
    'HIDDEN': FeatureState.hidden,
    'VISIBLE': FeatureState.visible,
  };

  @override
  FeatureState parseState(String state) {
    return _jsonStateToFeatureStateMap[state] ?? defaultState;
  }

  @override
  FeatureState get defaultState => FeatureState.hidden;
}
