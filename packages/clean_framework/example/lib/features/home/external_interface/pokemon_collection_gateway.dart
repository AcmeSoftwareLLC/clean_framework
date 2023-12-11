import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_failure_response.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_request.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_success_response.dart';

class PokemonCollectionFailureInput extends FailureInput {
  PokemonCollectionFailureInput({required this.type, super.message});

  final PokemonFailureType type;
}

class PokemonCollectionGateway extends Gateway<
    PokemonCollectionGatewayOutput,
    PokemonCollectionRequest,
    PokemonSuccessResponse,
    PokemonCollectionSuccessInput> {
  @override
  PokemonCollectionRequest buildRequest(PokemonCollectionGatewayOutput output) {
    return PokemonCollectionRequest();
  }

  @override
  PokemonCollectionFailureInput onFailure(
    PokemonFailureResponse failureResponse,
  ) {
    return PokemonCollectionFailureInput(
      message: failureResponse.message,
      type: failureResponse.type,
    );
  }

  @override
  PokemonCollectionSuccessInput onSuccess(PokemonSuccessResponse response) {
    final deserializer = Deserializer(response.data);

    return PokemonCollectionSuccessInput(
      pokemonIdentities: deserializer.getList(
        'results',
        converter: PokemonIdentity.fromJson,
      ),
    );
  }
}

class PokemonCollectionGatewayOutput extends Output {
  @override
  List<Object?> get props => [];
}

class PokemonCollectionSuccessInput extends SuccessInput {
  PokemonCollectionSuccessInput({required this.pokemonIdentities});

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

class PokemonCollectionRequest extends GetPokemonRequest {
  @override
  String get resource => 'pokemon';

  @override
  Map<String, dynamic> get queryParams => {'limit': 1000};
}
