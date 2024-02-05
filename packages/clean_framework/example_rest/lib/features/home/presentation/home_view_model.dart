import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/features/home/models/pokemon_model.dart';
import 'package:flutter/foundation.dart';

class HomeViewModel extends ViewModel {
  HomeViewModel({
    required this.pokemons,
    required this.isLoading,
    required this.hasFailedLoading,
    required this.loggedInEmail,
    required this.errorMessage,
    required this.onRetry,
    required this.onRefresh,
    required this.onSearch,
  });

  final List<PokemonModel> pokemons;
  final bool isLoading;
  final bool hasFailedLoading;
  final String loggedInEmail;
  final String errorMessage;

  final VoidCallback onRetry;
  final AsyncCallback onRefresh;
  final ValueChanged<String> onSearch;

  @override
  List<Object?> get props {
    return [pokemons, isLoading, hasFailedLoading, loggedInEmail, errorMessage];
  }
}
