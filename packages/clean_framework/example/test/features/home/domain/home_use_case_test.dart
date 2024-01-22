import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/home/domain/home_state.dart';
import 'package:clean_framework_example/features/home/domain/home_domain_outputs.dart';
import 'package:clean_framework_example/features/home/domain/home_use_case.dart';
import 'package:clean_framework_example/features/home/external_interface/pokemon_collection_gateway.dart';
import 'package:clean_framework_example/features/home/models/pokemon_model.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const baseImageUrl = 'https://raw.githubusercontent.com'
      '/PokeAPI/sprites/master/sprites/pokemon/other/dream-world';

  final pokemons = [
    PokemonModel(
      name: 'PIKACHU',
      imageUrl: '$baseImageUrl/45.svg',
    ),
    PokemonModel(
      name: 'CHARMANDER',
      imageUrl: '$baseImageUrl/4.svg',
    ),
  ];

  group('HomeUseCase test |', () {
    useCaseTest<HomeUseCase, HomeState, HomeDomainToUIOutput>(
      'fetch Pokemon; success',
      provider: homeUseCaseProvider,
      execute: (useCase) {
        _mockSuccess(useCase);

        return useCase.fetchPokemons();
      },
      expect: () => [
        HomeDomainToUIOutput(
          pokemons: [],
          status: HomeStatus.loading,
          isRefresh: false,
          loggedInEmail: '',
          errorMessage: '',
        ),
        HomeDomainToUIOutput(
          pokemons: pokemons,
          status: HomeStatus.loaded,
          isRefresh: false,
          loggedInEmail: '',
          errorMessage: '',
        ),
      ],
    );

    useCaseTest<HomeUseCase, HomeState, HomeDomainToUIOutput>(
      'refresh Pokemon; success',
      provider: homeUseCaseProvider,
      execute: (useCase) {
        _mockSuccess(useCase);

        return useCase.fetchPokemons(isRefresh: true);
      },
      expect: () {
        return [
          HomeDomainToUIOutput(
            pokemons: pokemons,
            status: HomeStatus.loaded,
            isRefresh: true,
            loggedInEmail: '',
            errorMessage: '',
          ),
          HomeDomainToUIOutput(
            pokemons: pokemons,
            status: HomeStatus.loaded,
            isRefresh: false,
            loggedInEmail: '',
            errorMessage: '',
          ),
        ];
      },
    );

    useCaseTest<HomeUseCase, HomeState, HomeDomainToUIOutput>(
      'fetch Pokemon; failure',
      provider: homeUseCaseProvider,
      execute: (useCase) {
        _mockFailure(useCase);

        return useCase.fetchPokemons();
      },
      expect: () => [
        HomeDomainToUIOutput(
          pokemons: [],
          status: HomeStatus.loading,
          isRefresh: false,
          loggedInEmail: '',
          errorMessage: '',
        ),
        HomeDomainToUIOutput(
          pokemons: [],
          status: HomeStatus.failed,
          isRefresh: false,
          loggedInEmail: '',
          errorMessage: '',
        ),
      ],
    );

    useCaseTest<HomeUseCase, HomeState, HomeDomainToUIOutput>(
      'refresh Pokemon; failure',
      provider: homeUseCaseProvider,
      execute: (useCase) {
        _mockFailure(useCase);

        return useCase.fetchPokemons(isRefresh: true);
      },
      expect: () => [
        HomeDomainToUIOutput(
          pokemons: [],
          status: HomeStatus.failed,
          isRefresh: true,
          loggedInEmail: '',
          errorMessage: '',
        ),
        HomeDomainToUIOutput(
          pokemons: [],
          status: HomeStatus.loaded,
          isRefresh: false,
          loggedInEmail: '',
          errorMessage: '',
        ),
      ],
    );

    useCaseTest<HomeUseCase, HomeState, HomeDomainToUIOutput>(
      'search pokemon',
      provider: homeUseCaseProvider,
      seed: (e) => e.copyWith(
        pokemons: [
          PokemonModel(
            name: 'PIKACHU',
            imageUrl: '$baseImageUrl/45.svg',
          ),
          PokemonModel(
            name: 'CHARMANDER',
            imageUrl: '$baseImageUrl/4.svg',
          ),
        ],
        status: HomeStatus.loaded,
      ),
      execute: (useCase) {
        return useCase.setInput(PokemonSearchDomainInput(name: 'pika'));
      },
      expect: () => [
        HomeDomainToUIOutput(
          pokemons: [
            PokemonModel(
              name: 'PIKACHU',
              imageUrl: '$baseImageUrl/45.svg',
            ),
          ],
          status: HomeStatus.loaded,
          isRefresh: false,
          loggedInEmail: '',
          errorMessage: '',
        ),
      ],
    );
  });
}

void _mockSuccess(HomeUseCase useCase) {
  useCase.subscribe<PokemonCollectionDomainToGatewayOutput,
      PokemonCollectionSuccessDomainInput>(
    (_) async {
      return Either.right(
        PokemonCollectionSuccessDomainInput(
          pokemonIdentities: [
            PokemonIdentity(name: 'pikachu', id: '45'),
            PokemonIdentity(name: 'charmander', id: '4'),
          ],
        ),
      );
    },
  );
}

void _mockFailure(HomeUseCase useCase) {
  useCase.subscribe<PokemonCollectionDomainToGatewayOutput,
      PokemonCollectionSuccessDomainInput>(
    (_) async {
      return Either.left(FailureDomainInput(message: 'No Internet'));
    },
  );
}
