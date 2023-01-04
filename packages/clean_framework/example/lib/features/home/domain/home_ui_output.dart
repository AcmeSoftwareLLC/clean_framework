import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/features/home/domain/home_entity.dart';

class HomeUIOutput extends Output {
  HomeUIOutput({
    required this.pokemons,
    required this.isRefresh,
  });

  final List<PokemonModel> pokemons;
  final bool isRefresh;

  @override
  List<Object?> get props => [pokemons, isRefresh];
}
