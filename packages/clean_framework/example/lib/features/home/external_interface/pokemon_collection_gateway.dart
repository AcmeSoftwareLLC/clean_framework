import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/core/pokemon/pokemon_failure_response.dart';
import 'package:clean_framework_example_rest/core/pokemon/pokemon_request.dart';
import 'package:clean_framework_example_rest/core/pokemon/pokemon_success_response.dart';
import 'package:clean_framework_example_rest/features/home/domain/home_domain_inputs.dart';
import 'package:clean_framework_example_rest/features/home/domain/home_domain_models.dart';

class PokemonCollectionGateway extends Gateway<
    PokemonCollectionDomainToGatewayModel,
    PokemonCollectionRequest,
    PokemonSuccessResponse,
    PokemonCollectionSuccessDomainInput> {
  @override
  PokemonCollectionRequest buildRequest(
      PokemonCollectionDomainToGatewayModel domainModel) {
    return PokemonCollectionRequest();
  }

  @override
  PokemonCollectionFailureDomainInput onFailure(
    PokemonFailureResponse failureResponse,
  ) {
    return PokemonCollectionFailureDomainInput(
      message: failureResponse.message,
      type: failureResponse.type,
    );
  }

  @override
  PokemonCollectionSuccessDomainInput onSuccess(
      PokemonSuccessResponse response) {
    final deserializer = Deserializer(response.data);

    return PokemonCollectionSuccessDomainInput(
      pokemonIdentities: deserializer.getList(
        'results',
        converter: PokemonIdentity.fromJson,
      ),
    );
  }
}

class PokemonCollectionRequest extends GetPokemonRequest {
  @override
  String get resource => 'pokemon';

  @override
  Map<String, dynamic> get queryParams => {'limit': 1000};
}
