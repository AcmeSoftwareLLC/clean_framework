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

  group('FeatureBuilder tests || different value type ||', () {
    testWidgets(
      'boolean',
      (tester) async {
        await tester.pumpWidget(
          FeatureScope<FakeJsonFeatureProvider>(
            register: () => FakeJsonFeatureProvider(),
            loader: (featureProvider) async => featureProvider.load(),
            child: MaterialApp(
              builder: (context, child) {
                return FeatureBuilder<bool>(
                  flagKey: 'boolean',
                  defaultValue: false,
                  builder: (context, value) {
                    return Text(value.toString());
                  },
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('true'), findsOneWidget);
      },
    );

    testWidgets(
      'boolean',
      (tester) async {
        await tester.pumpWidget(
          FeatureScope<FakeJsonFeatureProvider>(
            register: () => FakeJsonFeatureProvider(),
            loader: (featureProvider) async => featureProvider.load(),
            child: MaterialApp(
              builder: (context, child) {
                return FeatureBuilder<bool>(
                  flagKey: 'boolean',
                  defaultValue: false,
                  builder: (context, value) {
                    return Text(value.toString());
                  },
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('true'), findsOneWidget);
      },
    );

    testWidgets(
      'number',
      (tester) async {
        await tester.pumpWidget(
          FeatureScope<FakeJsonFeatureProvider>(
            register: () => FakeJsonFeatureProvider(),
            loader: (featureProvider) async => featureProvider.load(),
            child: MaterialApp(
              builder: (context, child) {
                return FeatureBuilder<int>(
                  flagKey: 'color',
                  defaultValue: 4285140397,
                  builder: (context, value) {
                    return Text(value.toString());
                  },
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('4294901760'), findsOneWidget);
      },
    );

    testWidgets(
      'object',
      (tester) async {
        await tester.pumpWidget(
          FeatureScope<FakeJsonFeatureProvider>(
            register: () => FakeJsonFeatureProvider(),
            loader: (featureProvider) async => featureProvider.load(),
            child: MaterialApp(
              builder: (context, child) {
                return FeatureBuilder<List>(
                  flagKey: 'object',
                  defaultValue: [0, 0],
                  builder: (context, value) {
                    return Text(value.toString());
                  },
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('[1, 2]'), findsOneWidget);
      },
    );

    testWidgets(
      'shows default value on error',
      (tester) async {
        await tester.pumpWidget(
          FeatureScope<FakeJsonFeatureProvider>(
            register: () => FakeJsonFeatureProvider(),
            loader: (featureProvider) async => featureProvider.load(),
            child: MaterialApp(
              builder: (context, child) {
                return FeatureBuilder<List>(
                  flagKey: 'objects', // invalid key
                  defaultValue: [0, 0],
                  builder: (context, value) {
                    print(value);
                    return Text(value.toString());
                  },
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('[0, 0]'), findsOneWidget);
      },
    );

    testWidgets(
      'default state is enabled',
      (tester) async {
        await tester.pumpWidget(
          FeatureScope<NewTitleFeatureProvider>(
            register: () => NewTitleFeatureProvider(),
            loader: (featureProvider) async => featureProvider.load(),
            child: MaterialApp(
              builder: (context, child) {
                return FeatureBuilder<bool>(
                  flagKey: 'newTitle',
                  defaultValue: false,
                  builder: (context, value) {
                    return Text(value.toString());
                  },
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('true'), findsOneWidget);
      },
    );
  });
}

class NewTitleFeatureProvider extends JsonFeatureProvider {
  void load() {
    feed({"newTitle": {}});
  }
}

class FakeJsonFeatureProvider extends JsonFeatureProvider {
  void load() {
    feed(
      {
        "newTitle": {"state": "disabled"},
        "object": {
          "returnType": "object",
          "variants": {
            "a": [1, 2],
            "b": [2, 3]
          },
          "defaultVariant": "a",
          "state": "enabled"
        },
        "boolean": {
          "returnType": "boolean",
          "variants": {"a": true, "b": false},
          "defaultVariant": "a",
          "state": "enabled"
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
              "action": {"variant": "restful"},
              "conditions": [
                {"context": "platform", "op": "equals", "value": "iOS"}
              ]
            },
            {
              "action": {"variant": "all"},
              "conditions": [
                {"context": "platform", "op": "equals", "value": "android"}
              ]
            }
          ]
        }
      },
    );
  }
}
