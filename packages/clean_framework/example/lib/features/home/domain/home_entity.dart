import 'package:clean_framework/clean_framework_core.dart';

class HomeEntity extends Entity {
  HomeEntity({
    this.pokemons = const [],
    this.pokemonNameQuery = '',
  });

  final List<PokemonModel> pokemons;
  final String pokemonNameQuery;

  @override
  List<Object?> get props => [pokemons, pokemonNameQuery];

  @override
  HomeEntity copyWith({
    List<PokemonModel>? pokemons,
    String? pokemonNameQuery,
  }) {
    return HomeEntity(
      pokemons: pokemons ?? this.pokemons,
      pokemonNameQuery: pokemonNameQuery ?? this.pokemonNameQuery,
    );
  }
}

class PokemonModel {
  PokemonModel({
    required this.name,
    required this.imageUrl,
  });

  final String name;
  final String imageUrl;
}
