import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:example/demo_router.dart';
import 'package:example/features/country/presentation/country_ui.dart';
import 'package:example/features/last_login/presentation/last_login_ui.dart';
import 'package:example/features/random_cat/presentation/random_cat_ui.dart';
import 'package:example/home_page.dart';
import 'package:example/providers.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomePage tests | ', () {
    testWidgets(
      'correct UI',
      (tester) async {
        await tester.pumpWidget(buildWidget(HomePage()));

        final appBarFinder = find.byType(AppBar);
        expect(
          find.descendant(
            of: appBarFinder,
            matching: find.text('Example Features'),
          ),
          findsOneWidget,
        );

        final listTileFinder = find.byType(ListTile);
        expect(listTileFinder, findsNWidgets(3));

        expect(
          find.descendant(
            of: listTileFinder.at(0),
            matching: find.text('Firebase'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: listTileFinder.at(1),
            matching: find.text('GraphQL'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: listTileFinder.at(2),
            matching: find.text('Rest API'),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'tap on Firebase tile should redirect to LastLoginUI',
      (tester) async {
        await tester.pumpWidget(buildWidget(HomePage()));

        final firebaseTileFinder = find.text('Firebase');
        expect(firebaseTileFinder, findsOneWidget);

        await tester.tap(firebaseTileFinder);
        await tester.pumpAndSettle();

        expect(find.byType(LastLoginUI), findsOneWidget);
      },
    );

    testWidgets(
      'tap on GraphQL tile should redirect to CountryUI',
      (tester) async {
        await tester.pumpWidget(buildWidget(HomePage()));

        final graphQLTileFinder = find.text('GraphQL');
        expect(graphQLTileFinder, findsOneWidget);

        await tester.tap(graphQLTileFinder);
        await tester.pumpAndSettle();

        expect(find.byType(CountryUI), findsOneWidget);
      },
    );

    testWidgets(
      'tap on Rest API tile should redirect to RandomCatUI',
      (tester) async {
        await tester.pumpWidget(buildWidget(HomePage()));

        final restAPITileFinder = find.text('Rest API');
        expect(restAPITileFinder, findsOneWidget);

        await tester.tap(restAPITileFinder);
        // pumpAndSettle times out here; as the page has non-deterministic loading indicator
        // so pumping each frame individually
        await tester.pump();
        // Debounce of 500ms
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(RandomCatUI), findsOneWidget);
      },
    );
  });
}

Widget buildWidget(Widget widget) {
  return FeatureScope(
    register: () => FakeJsonFeatureProvider(),
    child: AppProvidersContainer(
      providersContext: providersContext,
      onBuild: (_, __) {},
      child: AppRouterScope(
        create: () => DemoRouter(),
        builder: (context) {
          return MaterialApp.router(
            routerConfig: context.router.config,
          );
        },
      ),
    ),
  );
}

class FakeJsonFeatureProvider extends JsonFeatureProvider {
  FakeJsonFeatureProvider() {
    feed(
      {
        "newTitle": {"state": "disabled"},
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
