import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/home/domain/home_entity.dart';
import 'package:clean_framework_example/features/home/domain/home_ui_output.dart';
import 'package:clean_framework_example/features/home/domain/home_use_case.dart';
import 'package:clean_framework_example/features/home/external_interface/pokemon_collection_gateway.dart';
import 'package:clean_framework_example/features/home/models/pokemon_model.dart';
import 'package:clean_framework_example/features/profile/domain/profile_use_case.dart';
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
    useCaseTest<HomeUseCase, HomeEntity, HomeUIOutput>(
      'fetch Pokemon; success',
      provider: homeUseCaseProvider,
      execute: (useCase) {
        _mockSuccess(useCase);

        return useCase.fetchPokemons();
      },
      expect: () => [
        HomeUIOutput(
          pokemons: [],
          status: HomeStatus.loading,
          isRefresh: false,
          lastViewedPokemon: '',
        ),
        HomeUIOutput(
          pokemons: pokemons,
          status: HomeStatus.loaded,
          isRefresh: false,
          lastViewedPokemon: '',
        ),
      ],
      verify: (useCase) {
        expect(
          useCase.debugEntity,
          HomeEntity(pokemons: pokemons, status: HomeStatus.loaded),
        );
      },
    );

    useCaseTest<HomeUseCase, HomeEntity, HomeUIOutput>(
      'refresh Pokemon; success',
      provider: homeUseCaseProvider,
      execute: (useCase) {
        _mockSuccess(useCase);

        return useCase.fetchPokemons(isRefresh: true);
      },
      expect: () {
        return [
          HomeUIOutput(
            pokemons: pokemons,
            status: HomeStatus.loaded,
            isRefresh: true,
            lastViewedPokemon: '',
          ),
          HomeUIOutput(
            pokemons: pokemons,
            status: HomeStatus.loaded,
            isRefresh: false,
            lastViewedPokemon: '',
          ),
        ];
      },
    );

    useCaseTest<HomeUseCase, HomeEntity, HomeUIOutput>(
      'fetch Pokemon; failure',
      provider: homeUseCaseProvider,
      execute: (useCase) {
        _mockFailure(useCase);

        return useCase.fetchPokemons();
      },
      expect: () => [
        HomeUIOutput(
          pokemons: [],
          status: HomeStatus.loading,
          isRefresh: false,
          lastViewedPokemon: '',
        ),
        HomeUIOutput(
          pokemons: [],
          status: HomeStatus.failed,
          isRefresh: false,
          lastViewedPokemon: '',
        ),
      ],
    );

    useCaseTest<HomeUseCase, HomeEntity, HomeUIOutput>(
      'refresh Pokemon; failure',
      provider: homeUseCaseProvider,
      execute: (useCase) {
        _mockFailure(useCase);

        return useCase.fetchPokemons(isRefresh: true);
      },
      expect: () => [
        HomeUIOutput(
          pokemons: [],
          status: HomeStatus.failed,
          isRefresh: true,
          lastViewedPokemon: '',
        ),
        HomeUIOutput(
          pokemons: [],
          status: HomeStatus.loaded,
          isRefresh: false,
          lastViewedPokemon: '',
        ),
      ],
    );

    useCaseTest<HomeUseCase, HomeEntity, HomeUIOutput>(
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
        return useCase.setInput(PokemonSearchInput(name: 'pika'));
      },
      expect: () => [
        HomeUIOutput(
          pokemons: [
            PokemonModel(
              name: 'PIKACHU',
              imageUrl: '$baseImageUrl/45.svg',
            ),
          ],
          status: HomeStatus.loaded,
          isRefresh: false,
          lastViewedPokemon: '',
        ),
      ],
    );

    useCaseBridgeTest<HomeUseCase, HomeEntity, HomeUIOutput, ProfileUseCase>(
      'update last viewed pokemon',
      from: profileUseCaseProvider,
      to: homeUseCaseProvider,
      seed: (e) => e.copyWith(
        lastViewedPokemon: 'CHARIZARD',
        status: HomeStatus.loaded,
      ),
      execute: (useCase) {
        useCase.debugEntityUpdate((e) => e.copyWith(name: 'PIKACHU'));
      },
      expect: () => [
        HomeUIOutput(
          pokemons: [],
          status: HomeStatus.loaded,
          isRefresh: false,
          lastViewedPokemon: 'PIKACHU',
        ),
      ],
    );
  });
}

void _mockSuccess(HomeUseCase useCase) {
  useCase
      .subscribe<PokemonCollectionGatewayOutput, PokemonCollectionSuccessInput>(
    (_) async {
      return Either.right(
        PokemonCollectionSuccessInput(
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
  useCase
      .subscribe<PokemonCollectionGatewayOutput, PokemonCollectionSuccessInput>(
    (_) async {
      return Either.left(FailureInput(message: 'No Internet'));
    },
  );
}
