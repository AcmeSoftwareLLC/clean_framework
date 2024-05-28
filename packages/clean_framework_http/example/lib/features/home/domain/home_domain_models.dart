import 'package:clean_framework/clean_framework.dart';

class HomeDomainToUIModel extends DomainModel {
  const HomeDomainToUIModel({required this.pokemons});

  final List<PokemonDomainToUIModel> pokemons;

  @override
  List<Object> get props => [pokemons];
}

class PokemonDomainToUIModel extends DomainModel {
  const PokemonDomainToUIModel({required this.name, required this.url});

  final String name;
  final String url;

  @override
  List<Object> get props => [name, url];
}

class PokemonDomainToGatewayModel extends DomainModel {
  @override
  List<Object?> get props => [];
}
