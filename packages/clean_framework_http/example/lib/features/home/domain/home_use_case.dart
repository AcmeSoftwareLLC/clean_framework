import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_http_example/features/home/adapter/pokemon_gateway.dart';

import 'package:clean_framework_http_example/features/home/domain/home_entity.dart';
import 'package:clean_framework_http_example/features/home/domain/home_ui_output.dart';

final _pokemonResUrlRegex = RegExp(r'https://pokeapi.co/api/v2/pokemon/(\d+)/');

class HomeUseCase extends UseCase<HomeEntity> {
  HomeUseCase()
      : super(
          entity: const HomeEntity(),
          transformers: [HomeUIOutputTransformer()],
        );

  Future<void> fetch() {
    return request<PokemonSuccessInput>(
      PokemonGatewayOutput(),
      onSuccess: (success) {
        return entity.copyWith(
          pokemons: success.pokemons.map((p) {
            final match = _pokemonResUrlRegex.firstMatch(p.url);

            return PokemonEntity(name: p.name, id: match?.group(1) ?? '0');
          }).toList(growable: false),
        );
      },
      onFailure: (failure) => entity,
    );
  }
}

class HomeUIOutputTransformer
    extends OutputTransformer<HomeEntity, HomeUIOutput> {
  @override
  HomeUIOutput transform(HomeEntity entity) {
    return HomeUIOutput(
      pokemons: entity.pokemons.map((p) {
        final url =
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/${p.id}.svg';

        return PokemonUIOutput(name: p.name, url: url);
      }).toList(),
    );
  }
}
