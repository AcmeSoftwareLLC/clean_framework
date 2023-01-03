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
          ],
        );

  void init() {
    request<PokemonCollectionGatewayOutput, PokemonCollectionSuccessInput>(
      PokemonCollectionGatewayOutput(),
      onSuccess: (success) => entity.copyWith(pokemons: success.pokemonNames),
      onFailure: (failure) => entity,
    );
  }
}

class HomeUIOutputTransformer
    extends OutputTransformer<HomeEntity, HomeUIOutput> {
  @override
  HomeUIOutput transform(HomeEntity entity) {
    return HomeUIOutput(pokemons: entity.pokemons);
  }
}
