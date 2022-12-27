import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/demo_router.dart';
import 'package:clean_framework_example/features/country/presentation/country_ui.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_example/routes.dart';
import 'package:clean_framework_graphql/clean_framework_graphql.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../home_page_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final router = DemoRouter();

  setupUITest(context: providersContext, router: router);

  final gateway = countryGatewayProvider.getGateway(providersContext);

  gateway.transport = (request) async {
    return Either.right(
      GraphQLSuccessResponse(
        data: {
          'countries': request.continentCode == 'NA'
              ? [
                  {
                    'name': 'United States',
                    'emoji': '🇺🇸',
                    'capital': 'Washington',
                  },
                ]
              : [
                  {
                    'name': 'Nepal',
                    'emoji': '🇳🇵',
                    'capital': 'Kathmandu',
                  },
                  {
                    'name': 'Japan',
                    'emoji': '🇯🇵',
                    'capital': 'Tokyo',
                  },
                ],
        },
      ),
    );
  };

  group('CountryUI tests :: ', () {
    uiTest(
      'lists countries for default continent',
      builder: () => CountryUI(),
      verify: (tester) async {
        final listTileFinder = find.byType(ListTile);

        expect(listTileFinder, findsNWidgets(2));

        final nepalTileFinder = listTileFinder.first;
        final japanTileFinder = listTileFinder.last;

        expect(
          find.descendant(of: nepalTileFinder, matching: find.text('Nepal')),
          findsOneWidget,
        );
        expect(
          find.descendant(of: nepalTileFinder, matching: find.text('🇳🇵')),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: nepalTileFinder,
            matching: find.text('Kathmandu'),
          ),
          findsOneWidget,
        );

        expect(
          find.descendant(of: japanTileFinder, matching: find.text('Japan')),
          findsOneWidget,
        );
        expect(
          find.descendant(of: japanTileFinder, matching: find.text('🇯🇵')),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: japanTileFinder,
            matching: find.text('Tokyo'),
          ),
          findsOneWidget,
        );
      },
    );

    uiTest(
      'tapping on country tile should navigate to detail page',
      parentBuilder: (child) => FeatureScope(
        register: () => FakeJsonFeatureProvider(),
        child: child,
      ),
      verify: (tester) async {
        router.go(Routes.countries);
        await tester.pumpAndSettle();

        final listTileFinder = find.byType(ListTile);

        expect(listTileFinder, findsNWidgets(2));

        final nepalTileFinder = listTileFinder.first;
        final japanTileFinder = listTileFinder.last;

        await tester.tap(nepalTileFinder);
        await tester.pumpAndSettle();

        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text('Nepal'),
          ),
          findsOneWidget,
        );

        expect(router.location, '/countries/Nepal?capital=Kathmandu');

        await tester.pageBack();
        await tester.pumpAndSettle();

        await tester.tap(japanTileFinder);
        await tester.pumpAndSettle();

        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text('Japan'),
          ),
          findsOneWidget,
        );

        expect(router.location, '/countries/Japan?capital=Tokyo');
      },
    );

    uiTest(
      'switching continent shows countries for the switched continent',
      builder: () => CountryUI(),
      postFrame: (tester) async {
        await tester.pump();
      },
      verify: (tester) async {
        final listTileFinder = find.byType(ListTile);
        expect(listTileFinder, findsNWidgets(2));

        final continentDropdownFinder = find.byType(
          type<DropdownButton<String>>(),
        );
        expect(continentDropdownFinder, findsOneWidget);

        await tester.tap(continentDropdownFinder);
        await tester.pumpAndSettle();

        final northAmericaOptionFinder = find.text('North America');
        expect(northAmericaOptionFinder, findsNWidgets(2));

        await tester.tap(northAmericaOptionFinder.last);
        await tester.pumpAndSettle();

        expect(listTileFinder, findsOneWidget);

        expect(
          find.descendant(
              of: listTileFinder, matching: find.text('United States')),
          findsOneWidget,
        );
        expect(
          find.descendant(of: listTileFinder, matching: find.text('🇺🇸')),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: listTileFinder,
            matching: find.text('Washington'),
          ),
          findsOneWidget,
        );
      },
    );
  });
}
