import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/features/home/domain/home_entity.dart';
import 'package:flutter/foundation.dart';

class HomeViewModel extends ViewModel {
  HomeViewModel({
    required this.pokemons,
    required this.onSearch,
  });

  final List<PokemonModel> pokemons;

  final ValueChanged<String> onSearch;

  @override
  List<Object?> get props => [pokemons];
}
