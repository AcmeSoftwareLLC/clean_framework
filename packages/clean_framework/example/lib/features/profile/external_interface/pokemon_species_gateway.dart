import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/core/pokemon/pokemon_request.dart';
import 'package:clean_framework_example_rest/core/pokemon/pokemon_success_response.dart';
import 'package:clean_framework_example_rest/features/profile/domain/profile_domain_inputs.dart';
import 'package:clean_framework_example_rest/features/profile/domain/profile_domain_models.dart';
import 'package:clean_framework_example_rest/features/profile/models/pokemon_species_model.dart';

class PokemonSpeciesGateway extends Gateway<
    PokemonSpeciesDomainToGatewayModel,
    PokemonSpeciesRequest,
    PokemonSuccessResponse,
    PokemonSpeciesSuccessDomainInput> {
  @override
  PokemonSpeciesRequest buildRequest(
      PokemonSpeciesDomainToGatewayModel domainModel) {
    return PokemonSpeciesRequest(name: domainModel.name);
  }

  @override
  FailureDomainInput onFailure(FailureResponse failureResponse) {
    return FailureDomainInput(message: failureResponse.message);
  }

  @override
  PokemonSpeciesSuccessDomainInput onSuccess(PokemonSuccessResponse response) {
    return PokemonSpeciesSuccessDomainInput(
      species: PokemonSpeciesModel.fromJson(response.data),
    );
  }
}

class PokemonSpeciesRequest extends GetPokemonRequest {
  PokemonSpeciesRequest({required this.name});

  final String name;

  @override
  String get resource => 'pokemon-species/$name';
}
