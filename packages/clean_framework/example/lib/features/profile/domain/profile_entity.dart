import 'package:clean_framework/clean_framework_core.dart';

class ProfileEntity extends Entity {
  ProfileEntity({
    this.types = const [],
    this.description = '',
    this.height = 0,
    this.weight = 0,
  });

  final List<String> types;
  final String description;
  final int height;
  final int weight;

  @override
  List<Object?> get props => [types, description, height, weight];

  @override
  ProfileEntity copyWith({
    List<String>? types,
    String? description,
    int? height,
    int? weight,
  }) {
    return ProfileEntity(
      types: types ?? this.types,
      description: description ?? this.description,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }
}
