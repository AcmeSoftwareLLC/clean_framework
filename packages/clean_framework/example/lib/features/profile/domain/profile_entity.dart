import 'package:clean_framework/clean_framework_core.dart';

class ProfileEntity extends Entity {
  ProfileEntity({this.types = const []});

  final List<String> types;

  @override
  List<Object?> get props => [types];

  @override
  ProfileEntity copyWith({List<String>? types}) {
    return ProfileEntity(
      types: types ?? this.types,
    );
  }
}
