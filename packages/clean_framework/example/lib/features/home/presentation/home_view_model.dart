import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/features/home/domain/home_entity.dart';
import 'package:flutter/foundation.dart';

class HomeViewModel extends ViewModel {
  HomeViewModel({
    required this.pokemons,
    required this.isLoading,
    required this.hasFailedLoading,
    required this.onRetry,
    required this.onRefresh,
    required this.onSearch,
  });

  final List<PokemonModel> pokemons;
  final bool isLoading;
  final bool hasFailedLoading;

  final VoidCallback onRetry;
  final AsyncCallback onRefresh;
  final ValueChanged<String> onSearch;

  @override
  List<Object?> get props => [pokemons, isLoading, hasFailedLoading];
}
