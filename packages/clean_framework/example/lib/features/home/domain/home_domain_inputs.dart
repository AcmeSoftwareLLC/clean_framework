import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/core/pokemon/pokemon_failure_response.dart';

class PokemonCollectionFailureDomainInput extends FailureDomainInput {
  PokemonCollectionFailureDomainInput({required this.type, super.message});

  final PokemonFailureType type;
}

class PokemonCollectionSuccessDomainInput extends SuccessDomainInput {
  PokemonCollectionSuccessDomainInput({required this.pokemonIdentities});

  final List<PokemonIdentity> pokemonIdentities;
}

final _pokemonResUrlRegex = RegExp(r'https://pokeapi.co/api/v2/pokemon/(\d+)/');

class PokemonIdentity {
  PokemonIdentity({required this.name, required this.id});

  final String name;
  final String id;

  factory PokemonIdentity.fromJson(Map<String, dynamic> json) {
    final deserializer = Deserializer(json);

    final match = _pokemonResUrlRegex.firstMatch(deserializer.getString('url'));

    return PokemonIdentity(
      name: deserializer.getString('name'),
      id: match?.group(1) ?? '0',
    );
  }
}
