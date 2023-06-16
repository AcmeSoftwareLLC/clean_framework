import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/home/domain/home_entity.dart';
import 'package:clean_framework_example/features/home/domain/home_ui_output.dart';
import 'package:clean_framework_example/features/home/external_interface/pokemon_collection_gateway.dart';
import 'package:clean_framework_example/features/home/models/pokemon_model.dart';

const _spritesBaseUrl =
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites';

class HomeUseCase extends UseCase<HomeEntity> {
  HomeUseCase()
      : super(
          entity: HomeEntity(),
          transformers: [
            HomeUIOutputTransformer(),
            PokemonSearchInputTransformer(),
            LoggedInEmailInputTransformer(),
          ],
        );

  Future<void> fetchPokemons({bool isRefresh = false}) async {
    if (!isRefresh) {
      entity = entity.copyWith(status: HomeStatus.loading);
    }

    final input = await getInput(PokemonCollectionGatewayOutput());
    switch (input) {
      case Success(:PokemonCollectionSuccessInput input):
        final pokemons = input.pokemonIdentities.map(_resolvePokemon);

        entity = entity.copyWith(
          pokemons: pokemons.toList(growable: false),
          status: HomeStatus.loaded,
          isRefresh: isRefresh,
        );
      case _:
        entity = entity.copyWith(
          status: HomeStatus.failed,
          isRefresh: isRefresh,
        );
    }

    if (isRefresh) {
      entity = entity.copyWith(isRefresh: false, status: HomeStatus.loaded);
    }
  }

  PokemonModel _resolvePokemon(PokemonIdentity pokemon) {
    return PokemonModel(
      name: pokemon.name.toUpperCase(),
      imageUrl: '$_spritesBaseUrl/pokemon/other/dream-world/${pokemon.id}.svg',
    );
  }
}

class PokemonSearchInput extends SuccessInput {
  PokemonSearchInput({required this.name});

  final String name;
}

class HomeUIOutputTransformer
    extends OutputTransformer<HomeEntity, HomeUIOutput> {
  @override
  HomeUIOutput transform(HomeEntity entity) {
    final filteredPokemons = entity.pokemons.where(
      (pokemon) {
        final pokeName = pokemon.name.toLowerCase();
        return pokeName.contains(entity.pokemonNameQuery.toLowerCase());
      },
    );

    return HomeUIOutput(
      pokemons: filteredPokemons.toList(growable: false),
      status: entity.status,
      isRefresh: entity.isRefresh,
      loggedInEmail: entity.loggedInEmail,
    );
  }
}

class PokemonSearchInputTransformer
    extends InputTransformer<HomeEntity, PokemonSearchInput> {
  @override
  HomeEntity transform(HomeEntity entity, PokemonSearchInput input) {
    return entity.copyWith(pokemonNameQuery: input.name);
  }
}

class LoggedInEmailInput extends SuccessInput {
  LoggedInEmailInput({required this.email});

  final String email;
}

class LoggedInEmailInputTransformer
    extends InputTransformer<HomeEntity, LoggedInEmailInput> {
  @override
  HomeEntity transform(HomeEntity entity, LoggedInEmailInput input) {
    return entity.copyWith(loggedInEmail: input.email);
  }
}
