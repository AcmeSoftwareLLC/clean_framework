import 'package:clean_framework/clean_framework_core.dart';

class ProfileEntity extends Entity {
  ProfileEntity({this.types = const [], this.description = ''});

  final List<String> types;
  final String description;

  @override
  List<Object?> get props => [types, description];

  @override
  ProfileEntity copyWith({List<String>? types, String? description}) {
    return ProfileEntity(
      types: types ?? this.types,
      description: description ?? this.description,
    );
  }
}
