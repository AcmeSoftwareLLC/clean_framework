import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_request.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_success_response.dart';
import 'package:clean_framework_example/features/profile/models/pokemon_species_model.dart';

class PokemonSpeciesGateway extends Gateway<PokemonSpeciesGatewayOutput,
    PokemonSpeciesRequest, PokemonSuccessResponse, PokemonSpeciesSuccessInput> {
  @override
  PokemonSpeciesRequest buildRequest(PokemonSpeciesGatewayOutput output) {
    return PokemonSpeciesRequest(name: output.name);
  }

  @override
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput(message: failureResponse.message);
  }

  @override
  PokemonSpeciesSuccessInput onSuccess(PokemonSuccessResponse response) {
    return PokemonSpeciesSuccessInput(
      species: PokemonSpeciesModel.fromJson(response.data),
    );
  }
}

class PokemonSpeciesGatewayOutput extends Output {
  PokemonSpeciesGatewayOutput({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}

class PokemonSpeciesSuccessInput extends SuccessInput {
  PokemonSpeciesSuccessInput({required this.species});

  final PokemonSpeciesModel species;
}

class PokemonSpeciesRequest extends GetPokemonRequest {
  PokemonSpeciesRequest({required this.name});

  final String name;

  @override
  String get resource => 'pokemon-species/$name';
}
