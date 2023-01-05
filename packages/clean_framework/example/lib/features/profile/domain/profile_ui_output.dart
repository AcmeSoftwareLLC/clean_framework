import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/features/profile/domain/profile_entity.dart';

class ProfileUIOutput extends Output {
  ProfileUIOutput({
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
