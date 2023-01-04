import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/features/home/domain/home_entity.dart';
import 'package:clean_framework_example/features/home/domain/home_ui_output.dart';
import 'package:clean_framework_example/features/home/external_interface/pokemon_collection_gateway.dart';

class HomeUseCase extends UseCase<HomeEntity> {
  HomeUseCase()
      : super(
          entity: HomeEntity(),
          transformers: [
            HomeUIOutputTransformer(),
            PokemonSearchInputTransformer(),
          ],
        );

  void init() {
    request<PokemonCollectionGatewayOutput, PokemonCollectionSuccessInput>(
      PokemonCollectionGatewayOutput(),
      onSuccess: (success) {
        return entity.copyWith(
          pokemons: success.pokemonIdentities
              .map(_resolvePokemon)
              .toList(growable: false),
        );
      },
      onFailure: (failure) => entity,
    );
  }

  PokemonModel _resolvePokemon(PokemonIdentity pokemon) {
    return PokemonModel(
      name: pokemon.name.toUpperCase(),
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/${pokemon.id}.svg',
    );
  }
}

class PokemonSearchInput extends Input {
  PokemonSearchInput({required this.name});

  final String name;
}

class HomeUIOutputTransformer
    extends OutputTransformer<HomeEntity, HomeUIOutput> {
  @override
  HomeUIOutput transform(HomeEntity entity) {
    final filteredPokemons = entity.pokemons.where(
      (pokemon) {
        return pokemon.name
            .toLowerCase()
            .contains(entity.pokemonNameQuery.toLowerCase());
      },
    );

    return HomeUIOutput(
      pokemons: filteredPokemons.toList(growable: false),
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
