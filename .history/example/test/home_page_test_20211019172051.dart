import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework_example/home_page.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  uiTest(
      'lists countries for default continent',
      context: providersContext,
      builder: () => HomePage(),
      verify: (tester) async {
        final listTileFinder = find.byType(HomePage);

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
}