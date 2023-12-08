import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/home/domain/home_entity.dart';
import 'package:clean_framework_example/features/home/models/pokemon_model.dart';

class HomeUIOutput extends Output {
  HomeUIOutput({
    required this.pokemons,
    required this.status,
    required this.isRefresh,
    required this.loggedInEmail,
    required this.errorMessage,
  });

  final List<PokemonModel> pokemons;
  final HomeStatus status;
  final bool isRefresh;
  final String loggedInEmail;
  final String errorMessage;

  @override
  List<Object?> get props => [
        pokemons,
        status,
        isRefresh,
        loggedInEmail,
        errorMessage,
      ];
}
