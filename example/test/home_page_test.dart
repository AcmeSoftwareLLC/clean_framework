import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/country/presentation/country_ui.dart';
import 'package:clean_framework_example/features/last_login/presentation/last_login_ui.dart';
import 'package:clean_framework_example/features/random_cat/presentation/random_cat_ui.dart';
import 'package:clean_framework_example/home_page.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_example/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    router.reset();
  });

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
  return AppProvidersContainer(
    providersContext: providersContext,
    onBuild: (_, __) {},
    child: MaterialApp.router(
      routeInformationParser: router.informationParser,
      routerDelegate: router.delegate,
    ),
  );
}
