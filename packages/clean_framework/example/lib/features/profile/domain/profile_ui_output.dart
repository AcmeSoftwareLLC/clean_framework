import 'package:clean_framework/clean_framework_core.dart';

class ProfileUIOutput extends Output {
  ProfileUIOutput({
    required this.types,
    required this.description,
  });

  final List<String> types;
  final String description;

  @override
  List<Object?> get props => [types, description];
}
