import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeatureBuilder tests ||', () {
    testWidgets('default value', (tester) async {
      await tester.pumpWidget(
        FeatureScope<FakeJsonFeatureProvider>(
          register: () => FakeJsonFeatureProvider(),
          loader: (featureProvider) async => featureProvider.load(),
          onLoaded: () {},
          child: MaterialApp(
            builder: (context, child) {
              return FeatureBuilder<String>(
                flagKey: 'exampleFeatures',
                valueType: FlagValueType.string,
                defaultValue: 'rest',
                builder: (context, value) {
                  return Text(value);
                },
              );
            },
          ),
        ),
      );

      expect(find.text('rest'), findsOneWidget);
    });

    testWidgets('default variant', (tester) async {
      await tester.pumpWidget(
        FeatureScope<FakeJsonFeatureProvider>(
          register: () => FakeJsonFeatureProvider(),
          loader: (featureProvider) async => featureProvider.load(),
          onLoaded: () {},
          child: MaterialApp(
            builder: (context, child) {
              return FeatureBuilder<String>(
                flagKey: 'exampleFeatures',
                valueType: FlagValueType.string,
                defaultValue: 'rest',
                builder: (context, value) {
                  return Text(value);
                },
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('firebase,graphql'), findsOneWidget);
    });

    testWidgets('alternative variant for iOS', (tester) async {
      await tester.pumpWidget(
        FeatureScope<FakeJsonFeatureProvider>(
          register: () => FakeJsonFeatureProvider(),
          loader: (featureProvider) async => featureProvider.load(),
          onLoaded: () {},
          child: MaterialApp(
            builder: (context, child) {
              return FeatureBuilder<String>(
                flagKey: 'exampleFeatures',
                valueType: FlagValueType.string,
                defaultValue: 'rest',
                evaluationContext: EvaluationContext(
                  {'platform': 'iOS'},
                ),
                builder: (context, value) {
                  return Text(value);
                },
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('graphql,rest'), findsOneWidget);
    });

    testWidgets('alternative variant for Android', (tester) async {
      await tester.pumpWidget(
        FeatureScope<FakeJsonFeatureProvider>(
          register: () => FakeJsonFeatureProvider(),
          loader: (featureProvider) async => featureProvider.load(),
          onLoaded: () {},
          child: MaterialApp(
            builder: (context, child) {
              return FeatureBuilder<String>(
                flagKey: 'exampleFeatures',
                valueType: FlagValueType.string,
                defaultValue: 'rest',
                evaluationContext: EvaluationContext(
                  {'platform': 'android'},
                ),
                builder: (context, value) {
                  return Text(value);
                },
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('firebase,graphql,rest'), findsOneWidget);
    });
  });
}

class FakeJsonFeatureProvider extends JsonFeatureProvider {
  void load() {
    feed(OpenFeatureFlags.fromJson('''{
  "newTitle": {
    "state": "disabled"
  },
  "color": {
    "returnType": "number",
    "variants": {
      "red": 4294901760,
      "green": 4278255360,
      "blue": 4278190335,
      "purple": 4285140397
    },
    "defaultVariant": "red",
    "state": "enabled"
  },
  "exampleFeatures": {
    "returnType": "string",
    "variants": {
      "query": "firebase,graphql",
      "restful": "graphql,rest",
      "traditional": "rest",
      "all": "firebase,graphql,rest"
    },
    "defaultVariant": "query",
    "state": "enabled",
    "rules": [
      {
        "action": {
          "variant": "restful"
        },
        "conditions": [
          {
            "context": "platform",
            "op": "equals",
            "value": "iOS"
          }
        ]
      },
      {
        "action": {
          "variant": "all"
        },
        "conditions": [
          {
            "context": "platform",
            "op": "equals",
            "value": "android"
          }
        ]
      }
    ]
  }
}'''));
  }
}
