import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/features/home/models/pokemon_model.dart';

enum HomeStatus { initial, loading, loaded, failed }

class HomeEntity extends Entity {
  HomeEntity({
    this.pokemons = const [],
    this.pokemonNameQuery = '',
    this.status = HomeStatus.initial,
    this.isRefresh = false,
    this.loggedInEmail = '',
    this.errorMessage = '',
  });

  final List<PokemonModel> pokemons;
  final String pokemonNameQuery;
  final HomeStatus status;
  final bool isRefresh;
  final String loggedInEmail;
  final String errorMessage;

  @override
  List<Object?> get props {
    return [
      pokemons,
      pokemonNameQuery,
      status,
      isRefresh,
      loggedInEmail,
      errorMessage,
    ];
  }

  @override
  HomeEntity copyWith({
    List<PokemonModel>? pokemons,
    String? pokemonNameQuery,
    HomeStatus? status,
    bool? isRefresh,
    String? loggedInEmail,
    String? errorMessage,
  }) {
    return HomeEntity(
      pokemons: pokemons ?? this.pokemons,
      pokemonNameQuery: pokemonNameQuery ?? this.pokemonNameQuery,
      status: status ?? this.status,
      isRefresh: isRefresh ?? this.isRefresh,
      loggedInEmail: loggedInEmail ?? this.loggedInEmail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
