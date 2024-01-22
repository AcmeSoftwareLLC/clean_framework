import 'package:clean_framework/clean_framework.dart';

class ProfileState extends UseCaseState {
  ProfileState({
    this.name = '',
    this.types = const [],
    this.description = '',
    this.height = 0,
    this.weight = 0,
    this.stats = const [],
  });

  final String name;
  final List<String> types;
  final String description;
  final int height;
  final int weight;
  final List<PokemonStatState> stats;

  @override
  List<Object?> get props => [name, types, description, height, weight, stats];

  @override
  ProfileState copyWith({
    String? name,
    List<String>? types,
    String? description,
    int? height,
    int? weight,
    List<PokemonStatState>? stats,
  }) {
    return ProfileState(
      name: name ?? this.name,
      types: types ?? this.types,
      description: description ?? this.description,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      stats: stats ?? this.stats,
    );
  }
}

class PokemonStatState extends UseCaseState {
  PokemonStatState({this.name = '', this.point = 0});

  final String name;
  final int point;

  @override
  List<Object?> get props => [name, point];
}
