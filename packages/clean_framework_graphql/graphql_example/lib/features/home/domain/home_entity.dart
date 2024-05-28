import 'package:clean_framework/clean_framework.dart';

class HomeEntity extends Entity {
  const HomeEntity({
    this.pokemonId = 0,
    this.pokemonName = '',
    this.pokemonOrder = 0,
    this.pokemonWeight = 0.0,
    this.pokemonHeight = 0.0,
  });

  final int pokemonId;
  final String pokemonName;
  final int pokemonOrder;
  final double pokemonWeight;
  final double pokemonHeight;

  @override
  List<Object?> get props => [
        pokemonId,
        pokemonName,
        pokemonOrder,
        pokemonWeight,
        pokemonHeight,
      ];

  @override
  HomeEntity copyWith({
    int? pokemonId,
    String? pokemonName,
    int? pokemonOrder,
    double? pokemonWeight,
    double? pokemonHeight,
  }) {
    return HomeEntity(
      pokemonId: pokemonId ?? this.pokemonId,
      pokemonName: pokemonName ?? this.pokemonName,
      pokemonOrder: pokemonOrder ?? this.pokemonOrder,
      pokemonWeight: pokemonWeight ?? this.pokemonWeight,
      pokemonHeight: pokemonHeight ?? this.pokemonHeight,
    );
  }
}
