import 'package:clean_framework/clean_framework.dart';

class HomeUIOutput extends Output {
  const HomeUIOutput({required this.pokemons});

  final List<PokemonUIOutput> pokemons;

  @override
  List<Object> get props => [pokemons];
}

class PokemonUIOutput extends Output {
  const PokemonUIOutput({required this.name, required this.url});

  final String name;
  final String url;

  @override
  List<Object> get props => [name, url];
}
