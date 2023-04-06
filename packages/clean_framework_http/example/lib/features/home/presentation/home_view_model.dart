import 'package:clean_framework/clean_framework.dart';

class HomeViewModel extends ViewModel {
  const HomeViewModel({required this.pokemons});

  final List<PokemonViewModel> pokemons;

  @override
  List<Object> get props => [pokemons];
}

class PokemonViewModel extends ViewModel {
  PokemonViewModel({required this.name, required this.imageUrl});

  final String name;
  final String imageUrl;

  @override
  List<Object> get props => [name, imageUrl];
}
