import 'package:clean_framework_rest/clean_framework_rest.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RestServiceOptions tests |', () {
    test(
      'correct base url',
      () {
        const options = RestServiceOptions(baseUrl: 'https://example.com');

        expect(options.baseUrl, equals('https://example.com'));
      },
    );

    test(
      'correct headers',
      () {
        const options = RestServiceOptions(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer token',
          },
        );

        expect(
          options.headers,
          equals({
            'Content-Type': 'application/json',
            'Authorization': 'Bearer token',
          }),
        );
      },
    );

    test(
      'json content type header is added by default if not provided',
      () {
        const options = RestServiceOptions(
          headers: {
            'Authorization': 'Bearer token',
          },
        );

        expect(
          options.headers,
          equals({
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer token',
          }),
        );
      },
    );

    test(
      'json content type header is added by default if not provided '
      'for sub classes of RestServiceOptions',
      () {
        const options = TestRestServiceOptions();

        expect(
          options.headers,
          equals({
            'Authorization': 'Bearer token',
            'Content-Type': 'application/json; charset=UTF-8',
          }),
        );
      },
    );
  });
}

class TestRestServiceOptions extends RestServiceOptions {
  const TestRestServiceOptions({super.baseUrl = ''});

  @override
  Map<String, String> buildHeaders() {
    return {
      'Authorization': 'Bearer token',
    };
  }
}
