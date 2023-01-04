import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/features/home/domain/home_entity.dart';

class HomeUIOutput extends Output {
  HomeUIOutput({required this.pokemons});

  final List<PokemonModel> pokemons;

  @override
  List<Object?> get props => [pokemons];
}
