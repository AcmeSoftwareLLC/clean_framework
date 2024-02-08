import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/features/profile/domain/profile_domain_models.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ViewModel {
  ProfileViewModel({
    required this.pokemonTypes,
    required this.description,
    required this.height,
    required this.weight,
    required this.stats,
  });

  final List<PokemonType> pokemonTypes;
  final String description;
  final String height;
  final String weight;
  final List<PokemonStat> stats;

  @override
  List<Object?> get props => [pokemonTypes, description, height, weight, stats];
}

class PokemonType {
  PokemonType(this.name)
      : color = _pokemonTypeColors[name] ?? Colors.white,
        emoji = _pokemonTypeEmojis[name] ?? '';

  final String name;
  final String emoji;
  final Color color;
}

const _pokemonTypeColors = <String, Color>{
  'normal': Color(0xFFA8A77A),
  'fire': Color(0xFFEE8130),
  'water': Color(0xFF6390F0),
  'electric': Color(0xFFF7D02C),
  'grass': Color(0xFF7AC74C),
  'ice': Color(0xFF96D9D6),
  'fighting': Color(0xFFC22E28),
  'poison': Color(0xFFA33EA1),
  'ground': Color(0xFFE2BF65),
  'flying': Color(0xFFA98FF3),
  'psychic': Color(0xFFF95587),
  'bug': Color(0xFFA6B91A),
  'rock': Color(0xFFB6A136),
  'ghost': Color(0xFF735797),
  'dragon': Color(0xFF6F35FC),
  'dark': Color(0xFF705746),
  'steel': Color(0xFFB7B7CE),
  'fairy': Color(0xFFD685AD),
};

const _pokemonTypeEmojis = <String, String>{
  'normal': '🔶',
  'fire': '🔥',
  'water': '💧',
  'electric': '⚡️',
  'grass': '🍃',
  'ice': '❄️',
  'fighting': '👊',
  'poison': '🍄',
  'ground': '🏔',
  'flying': '💨',
  'psychic': '👁️',
  'bug': '🕸',
  'rock': '🗿',
  'ghost': '👻',
  'dragon': '🐲',
  'dark': '🌙',
  'steel': '⚙️',
  'fairy': '🌈',
};
