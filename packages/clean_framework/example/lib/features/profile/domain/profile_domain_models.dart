import 'package:clean_framework/clean_framework.dart';

class ProfileDomainToUIModel extends DomainModel {
  ProfileDomainToUIModel({
    required this.types,
    required this.description,
    required this.height,
    required this.weight,
    required this.stats,
  });

  final List<String> types;
  final String description;
  final double height;
  final double weight;
  final List<PokemonStat> stats;

  @override
  List<Object?> get props => [types, description, height, weight, stats];
}

class PokemonStat {
  PokemonStat({required this.name, required this.point});

  final String name;
  final int point;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonStat &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          point == other.point;

  @override
  int get hashCode => name.hashCode ^ point.hashCode;
}

class PokemonProfileDomainToGatewayModel extends DomainModel {
  PokemonProfileDomainToGatewayModel({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}

class PokemonSpeciesDomainToGatewayModel extends DomainModel {
  PokemonSpeciesDomainToGatewayModel({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}
