import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/home/models/pokemon_model.dart';

enum HomeStatus { initial, loading, loaded, failed }

class HomeEntity extends Entity {
  HomeEntity({
    this.pokemons = const [],
    this.pokemonNameQuery = '',
    this.status = HomeStatus.initial,
    this.isRefresh = false,
    this.loggedInEmail = '',
  });

  final List<PokemonModel> pokemons;
  final String pokemonNameQuery;
  final HomeStatus status;
  final bool isRefresh;
  final String loggedInEmail;

  @override
  List<Object?> get props {
    return [pokemons, pokemonNameQuery, status, isRefresh, loggedInEmail];
  }

  @override
  HomeEntity copyWith({
    List<PokemonModel>? pokemons,
    String? pokemonNameQuery,
    HomeStatus? status,
    bool? isRefresh,
    String? recentEmail,
  }) {
    return HomeEntity(
      pokemons: pokemons ?? this.pokemons,
      pokemonNameQuery: pokemonNameQuery ?? this.pokemonNameQuery,
      status: status ?? this.status,
      isRefresh: isRefresh ?? this.isRefresh,
      loggedInEmail: recentEmail ?? this.loggedInEmail,
    );
  }
}
