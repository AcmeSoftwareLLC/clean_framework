import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final logger = TestNetworkLogger();

  group('Network Logger tests |', () {
    test('pretty headers', () {
      final headers = logger.prettyHeaders(
        {'Authorization': 'Bearer token', 'Method': 'GET'},
      );

      expect(
        headers,
        equals('''
Authorization: Bearer token
Method: GET'''),
      );
    });

    test('pretty map', () {
      final headers = logger.prettyMap(
        {
          'name': 'Acme Software',
          'location': {'state': 'Ohio', 'country': 'United States'},
        },
      );

      expect(
        headers,
        equals('''
{
  "name": "Acme Software",
  "location": {
    "state": "Ohio",
    "country": "United States"
  }
}'''),
      );
    });

    test('print lines ', () {
      final result = logger.capture(() => logger.printInLines('Hello\nWorld'));

      expect(
        result,
        equals('''
║  Hello
║  World
║'''),
      );
    });

    test('print category ', () {
      final result = logger.capture(() => logger.printCategory('Hello World'));

      expect(
        result,
        equals('''
╟┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄ Hello World ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
║'''),
      );
    });

    test('print header ', () {
      final result = logger.capture(
        () => logger.printHeader('GET', 'https://example.com'),
      );

      expect(
        result,
        equals('''


╔╣ GET ╠═ https://example.com
║'''),
      );
    });

    test('print footer ', () {
      final result = logger.capture(logger.printFooter);

      expect(
        result,
        equals('''
╚════════════════════════════════════════════════════════════════════════════════════════════════════

'''),
      );
    });

    test('print gap ', () {
      final result = logger.capture(logger.printGap);

      expect(result, equals('║'));
    });
  });
}

class TestNetworkLogger extends NetworkLogger {
  @override
  void initialize() {}

  String capture(void Function() body) {
    final lines = <String>[];

    runZoned(
      body,
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) {
          lines.add(line);
        },
      ),
    );

    return lines.join('\n');
  }
}
