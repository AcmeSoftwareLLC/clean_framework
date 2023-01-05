import 'package:clean_framework/clean_framework_core.dart';

class ProfileUIOutput extends Output {
  ProfileUIOutput({required this.types});

  final List<String> types;

  @override
  List<Object?> get props => [types];
}
