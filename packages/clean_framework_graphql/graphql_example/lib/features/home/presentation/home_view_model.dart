import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ViewModel {
  const HomeViewModel({
    required this.pokemonId,
    required this.pokemonName,
    required this.pokemonOrder,
    required this.pokemonWeight,
    required this.pokemonHeight,
    required this.onRefreshAbility,
  });

  final int pokemonId;
  final String pokemonName;
  final int pokemonOrder;
  final double pokemonWeight;
  final double pokemonHeight;

  final VoidCallback onRefreshAbility;

  @override
  List<Object> get props => [
        pokemonId,
        pokemonName,
        pokemonOrder,
        pokemonWeight,
        pokemonHeight,
      ];
}
