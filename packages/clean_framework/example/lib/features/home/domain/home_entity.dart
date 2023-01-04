import 'package:clean_framework/clean_framework_core.dart';

enum HomeStatus { initial, loading, loaded, failed }

enum HomeRefreshStatus { initial, succeeded, failed }

class HomeEntity extends Entity {
  HomeEntity({
    this.pokemons = const [],
    this.pokemonNameQuery = '',
    this.status = HomeStatus.initial,
    this.isRefresh = false,
  });

  final List<PokemonModel> pokemons;
  final String pokemonNameQuery;
  final HomeStatus status;
  final bool isRefresh;

  @override
  List<Object?> get props {
    return [pokemons, pokemonNameQuery, status, isRefresh];
  }

  @override
  HomeEntity copyWith({
    List<PokemonModel>? pokemons,
    String? pokemonNameQuery,
    HomeStatus? status,
    bool? isRefresh,
  }) {
    return HomeEntity(
      pokemons: pokemons ?? this.pokemons,
      pokemonNameQuery: pokemonNameQuery ?? this.pokemonNameQuery,
      status: status ?? this.status,
      isRefresh: isRefresh ?? this.isRefresh,
    );
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
