import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_request.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_success_response.dart';

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
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput(message: failureResponse.message);
  }

  @override
  PokemonCollectionSuccessInput onSuccess(PokemonSuccessResponse response) {
    final deserializer = Deserializer(response.data);

    return PokemonCollectionSuccessInput(
      pokemonNames: deserializer.getList(
        'results',
        converter: (result) => result['name'],
      ),
    );
  }
}

class PokemonCollectionGatewayOutput extends Output {
  @override
  List<Object?> get props => [];
}

class PokemonCollectionSuccessInput extends SuccessInput {
  PokemonCollectionSuccessInput({
    required this.pokemonNames,
  });

  final List<String> pokemonNames;
}

class PokemonCollectionRequest extends GetPokemonRequest {
  @override
  String get resource => 'pokemon';
}
