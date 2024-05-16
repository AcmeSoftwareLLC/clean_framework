import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/core/pokemon/pokemon_success_response.dart';
import 'package:clean_framework_example_rest/features/home/domain/home_domain_models.dart';
import 'package:clean_framework_example_rest/features/home/external_interface/pokemon_collection_gateway.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PokemonCollectionGateway tests |', () {
    test('verify request', () async {
      final gateway = PokemonCollectionGateway();
      final gatewayOutput = PokemonCollectionDomainToGatewayModel();

      final request = await gateway.buildRequest(gatewayOutput);

      expect(request.resource, equals('pokemon'));
      expect(request.queryParams, equals({'limit': 1000}));

      expect(gatewayOutput, PokemonCollectionDomainToGatewayModel());
    });

    test('success', () async {
      final gateway = PokemonCollectionGateway()
        ..feedResponse(
          (request) async => Either.right(
            PokemonSuccessResponse(
              data: {
                'results': [
                  {
                    'name': 'pikachu',
                    'url': 'https://pokeapi.co/api/v2/pokemon/45/'
                  },
                  {
                    'name': 'charmander',
                    'url': 'https://pokeapi.co/api/v2/pokemon/5/'
                  }
                ]
              },
            ),
          ),
        );

      final input =
          await gateway.buildInput(PokemonCollectionDomainToGatewayModel());

      expect(input.isRight, isTrue);

      final identities = input.right.pokemonIdentities;

      expect(identities.first.name, equals('pikachu'));
      expect(identities.first.id, equals('45'));

      expect(identities.last.name, equals('charmander'));
      expect(identities.last.id, equals('5'));
    });

    test('failure', () async {
      final gateway = PokemonCollectionGateway()
        ..feedResponse(
          (request) async => Either.left(
            UnknownFailureResponse('No Internet'),
          ),
        );

      final input =
          await gateway.buildInput(PokemonCollectionDomainToGatewayModel());

      expect(input.isLeft, isTrue);

      expect(input.left.message, equals('No Internet'));
    });
  });
}
