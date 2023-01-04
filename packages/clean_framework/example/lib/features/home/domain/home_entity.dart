import 'package:clean_framework/clean_framework_core.dart';

class HomeEntity extends Entity {
  HomeEntity({this.pokemons = const []});

  final List<PokemonModel> pokemons;

  @override
  List<Object?> get props => [pokemons];

  @override
  HomeEntity copyWith({List<PokemonModel>? pokemons}) {
    return HomeEntity(pokemons: pokemons ?? this.pokemons);
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
