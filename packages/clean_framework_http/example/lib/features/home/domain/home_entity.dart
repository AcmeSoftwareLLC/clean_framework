import 'package:clean_framework/clean_framework.dart';

class HomeEntity extends Entity {
  const HomeEntity({this.pokemons = const []});

  final List<PokemonEntity> pokemons;

  @override
  List<Object> get props => [pokemons];

  @override
  HomeEntity copyWith({List<PokemonEntity>? pokemons}) {
    return HomeEntity(pokemons: pokemons ?? this.pokemons);
  }
}

class PokemonEntity {
  PokemonEntity({
    required this.name,
    required this.id,
  });

  final String name;
  final String id;
}
