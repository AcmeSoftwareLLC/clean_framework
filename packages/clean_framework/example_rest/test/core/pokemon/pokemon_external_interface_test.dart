import 'dart:io';

import 'package:clean_framework/clean_framework.dart' hide Response;
import 'package:clean_framework_example_rest/core/dependency_providers.dart';
import 'package:clean_framework_example_rest/core/pokemon/pokemon_request.dart';
import 'package:clean_framework_example_rest/providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('PokemonExternalInterface tests |', () {
    test('get request success', () async {
      final container = ProviderContainer(
        overrides: [
          restClientProvider.overrideWith(DioMock()),
        ],
      );

      final interface = pokemonExternalInterfaceProvider.read(container);
      final dio = restClientProvider.read(container);

      when(
        () => dio.get<Map<String, dynamic>>(
          'pokemon',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {'name': 'pikachu'},
          requestOptions: RequestOptions(path: 'pokemon'),
        ),
      );

      final result = await interface.request(TestPokemonRequest());

      expect(result.isRight, isTrue);
      expect(result.right.data, equals({'name': 'pikachu'}));
    });

    test('get request failure', () async {
      final container = ProviderContainer(
        overrides: [
          restClientProvider.overrideWith(DioMock()),
        ],
      );

      final interface = pokemonExternalInterfaceProvider.read(container);
      final dio = restClientProvider.read(container);

      when(
        () => dio.get<Map<String, dynamic>>(
          'pokemon',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(HttpException('No Internet'));

      final result = await interface.request(TestPokemonRequest());

      expect(result.isLeft, isTrue);
      expect(
        result.left.message,
        equals(HttpException('No Internet').toString()),
      );
    });
  });
}

class TestPokemonRequest extends GetPokemonRequest {
  @override
  String get resource => 'pokemon';
}

class DioMock extends Mock implements Dio {}
