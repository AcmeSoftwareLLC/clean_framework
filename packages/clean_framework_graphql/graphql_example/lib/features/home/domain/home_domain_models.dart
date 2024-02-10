import 'package:clean_framework/clean_framework.dart';

class HomeDomainToUIModel extends DomainModel {
  const HomeDomainToUIModel({
    required this.pokemonId,
    required this.pokemonName,
    required this.pokemonOrder,
    required this.pokemonWeight,
    required this.pokemonHeight,
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
}

class HomeDomainToGatewayModel extends DomainModel {
  const HomeDomainToGatewayModel({
    required this.id,
  });

  final int id;

  @override
  List<Object?> get props => [
        id,
      ];
}
