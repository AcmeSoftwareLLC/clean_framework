import 'package:clean_framework/clean_framework_core.dart';

class HomeUIOutput extends Output {
  HomeUIOutput({required this.pokemons});

  final List<String> pokemons;

  @override
  List<Object?> get props => [pokemons];
}
