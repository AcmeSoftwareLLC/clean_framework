import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/core/pokemon/pokemon_success_response.dart';
import 'package:clean_framework_example_rest/features/profile/domain/profile_domain_models.dart';
import 'package:clean_framework_example_rest/features/profile/external_interface/pokemon_profile_gateway.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PokemonProfileGateway tests |', () {
    test('verify request', () async {
      final gateway = PokemonProfileGateway();
      final gatewayOutput = PokemonProfileDomainToGatewayModel(name: 'pikachu');

      final request = await gateway.buildRequest(gatewayOutput);

      expect(request.resource, equals('pokemon/pikachu'));

      expect(
          gatewayOutput, PokemonProfileDomainToGatewayModel(name: 'pikachu'));
    });

    test('success', () async {
      final gateway = PokemonProfileGateway()
        ..feedResponse(
          (request) async => Either.right(
            PokemonSuccessResponse(
              data: {
                'base_experience': 112,
                'height': 4,
                'weight': 60,
                'stats': [
                  {
                    'base_stat': 35,
                    'effort': 0,
                    'stat': {
                      'name': 'hp',
                      'url': 'https://pokeapi.co/api/v2/stat/1/'
                    }
                  },
                  {
                    'base_stat': 55,
                    'effort': 0,
                    'stat': {
                      'name': 'attack',
                      'url': 'https://pokeapi.co/api/v2/stat/2/'
                    }
                  },
                  {
                    'base_stat': 40,
                    'effort': 0,
                    'stat': {
                      'name': 'defense',
                      'url': 'https://pokeapi.co/api/v2/stat/3/'
                    }
                  },
                  {
                    'base_stat': 50,
                    'effort': 0,
                    'stat': {
                      'name': 'special-attack',
                      'url': 'https://pokeapi.co/api/v2/stat/4/'
                    }
                  },
                  {
                    'base_stat': 50,
                    'effort': 0,
                    'stat': {
                      'name': 'special-defense',
                      'url': 'https://pokeapi.co/api/v2/stat/5/'
                    }
                  },
                  {
                    'base_stat': 90,
                    'effort': 2,
                    'stat': {
                      'name': 'speed',
                      'url': 'https://pokeapi.co/api/v2/stat/6/'
                    }
                  }
                ],
                'types': [
                  {
                    'slot': 1,
                    'type': {
                      'name': 'electric',
                      'url': 'https://pokeapi.co/api/v2/type/13/'
                    }
                  }
                ],
              },
            ),
          ),
        );

      final input = await gateway.buildInput(
        PokemonProfileDomainToGatewayModel(name: 'pikachu'),
      );

      expect(input.isRight, isTrue);

      final profile = input.right.profile;

      expect(profile.baseExperience, equals(112));
      expect(profile.height, equals(4));
      expect(profile.weight, equals(60));

      final stats = profile.stats;

      expect(stats.first.name, equals('hp'));
      expect(stats.first.baseStat, equals(35));

      expect(stats.last.name, equals('speed'));
      expect(stats.last.baseStat, equals(90));

      final type = profile.types.first;

      expect(type, equals('electric'));
    });

    test('failure', () async {
      final gateway = PokemonProfileGateway()
        ..feedResponse(
          (request) async => Either.left(
            UnknownFailureResponse('No Internet'),
          ),
        );

      final input = await gateway.buildInput(
        PokemonProfileDomainToGatewayModel(name: 'pikachu'),
      );

      expect(input.isLeft, isTrue);

      expect(input.left.message, equals('No Internet'));
    });
  });
}
