import 'package:clean_framework/clean_framework_core.dart';

class HomeEntity extends Entity {
  HomeEntity({this.pokemons = const []});

  final List<String> pokemons;

  @override
  List<Object?> get props => [pokemons];

  @override
  HomeEntity copyWith({List<String>? pokemons}) {
    return HomeEntity(pokemons: pokemons ?? this.pokemons);
  }
}
