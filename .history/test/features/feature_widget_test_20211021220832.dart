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
            (_) => TestFeatureStateMapper());

    final featureTester = FeatureTester<FeatureState>(featureStateProvider);

    final testWidget = MaterialApp(
        home: Column(
      children: [
        TestFeatureWidget(
          featureStateProvider,
        ),
        ElevatedButton(
          key: Key('loadButton'),
          child: Text('load'),
          onPressed: () {
            featureTester.featuresMap.append({
              'features': [
                {'name': 'login', 'version': '1.0', 'state': 'VISIBLE'},
              ]
            });
          },
        ),
        ElevatedButton(
          key: Key('hideButton'),
          child: Text('hide'),
          onPressed: () {
            featureTester.featuresMap.append({
              'features': [
                {'name': 'login', 'version': '1.0', 'state': 'HIDDEN'},
              ]
            });
          },
        )
      ],
    ));

    await featureTester.pumpWidget(tester, testWidget);

    expect(find.byType(TestFeatureWidget), findsOneWidget);
    expect(find.text('visible'), findsNothing);
    expect(find.byKey(Key('empty')), findsOneWidget);

    await tester.tap(find.byKey(Key('hideButton')));
    await tester.pump();

    await tester.tap(find.byKey(Key('loadButton')));
    await tester.pump(Duration(milliseconds: 500));
    await tester.pump(Duration(milliseconds: 500));
    await tester.pump(Duration(milliseconds: 500));
    await tester.pump(Duration(milliseconds: 500));
    await tester.pump(Duration(milliseconds: 500));

    await tester.pumpAndSettle();

    //debugDumpApp();

    expect(find.text('visible'), findsOneWidget);
    expect(find.byKey(Key('empty')), findsNothing);

    await tester.tap(find.byKey(Key('hideButton')));
    await tester.pump();

    expect(find.text('visible'), findsNothing);
    expect(find.byKey(Key('empty')), findsOneWidget);

    featureTester.dispose();
  });

  testWidgets('FeatureStatesProvider load error', (tester) async {
    final featureStateProvider =
        FeatureStateProvider<FeatureState, TestFeatureStateMapper>(
            (_) => TestFeatureStateMapper());

    final featureTester = FeatureTester<FeatureState>(featureStateProvider);

    final testWidget = MaterialApp(
        home: Column(
      children: [
        TestFeatureWidget(
          featureStateProvider,
        ),
        ElevatedButton(
          key: Key('loadButton'),
          child: Text('load'),
          onPressed: () {
            featureTester.featuresMap.append({});
          },
        ),
      ],
    ));

    await featureTester.pumpWidget(tester, testWidget);

    expect(find.byType(TestFeatureWidget), findsOneWidget);
    expect(find.text('visible'), findsNothing);
    expect(find.byKey(Key('empty')), findsOneWidget);

    await tester.tap(find.byKey(Key('hideButton')));
    await tester.pump();

    await tester.tap(find.byKey(Key('loadButton')));
    await tester.pump(Duration(milliseconds: 500));
    await tester.pump(Duration(milliseconds: 500));
    await tester.pump(Duration(milliseconds: 500));
    await tester.pump(Duration(milliseconds: 500));
    await tester.pump(Duration(milliseconds: 500));

    await tester.pumpAndSettle();

    //debugDumpApp();

    expect(find.text('visible'), findsOneWidget);
    expect(find.byKey(Key('empty')), findsNothing);

    await tester.tap(find.byKey(Key('hideButton')));
    await tester.pump();

    expect(find.text('visible'), findsNothing);
    expect(find.byKey(Key('empty')), findsOneWidget);

    featureTester.dispose();
  });
}

class TestFeatureWidget extends FeatureWidget<FeatureState> {
  TestFeatureWidget(provider)
      : super(
          feature: Feature(name: 'login'),
          provider: provider,
        );
  @override
  Widget builder(BuildContext context, FeatureState currentState) {
    switch (currentState) {
      case FeatureState.visible:
        return Text('visible');
      default:
        return Container(key: Key('empty'));
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
  get defaultState => FeatureState.hidden;
}
