import 'package:clean_framework/clean_framework_core.dart';

class ProfileUIOutput extends Output {
  ProfileUIOutput({
    required this.types,
    required this.description,
    required this.height,
    required this.weight,
  });

  final List<String> types;
  final String description;
  final double height;
  final double weight;

  @override
  List<Object?> get props => [types, description, height, weight];
}
