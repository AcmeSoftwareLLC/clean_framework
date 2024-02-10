import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_http/clean_framework_http.dart';
import 'package:clean_framework_http_example/features/home/adapter/pokemon_model.dart';
import 'package:clean_framework_http_example/features/home/domain/home_domain_inputs.dart';
import 'package:clean_framework_http_example/features/home/domain/home_domain_models.dart';

class PokemonGateway extends Gateway<PokemonDomainToGatewayModel,
    PokemonRequest, SuccessResponse, PokemonSuccessInput> {
  @override
  PokemonRequest buildRequest(PokemonDomainToGatewayModel output) {
    return PokemonRequest();
  }

  @override
  FailureDomainInput onFailure(FailureResponse failureResponse) {
    return FailureDomainInput(message: failureResponse.message);
  }

  @override
  PokemonSuccessInput onSuccess(JsonHttpSuccessResponse response) {
    final data = response.data.deserialize;
    final results = data.getList('results', converter: PokemonModel.fromJson);

    return PokemonSuccessInput(pokemons: results);
  }
}

class PokemonRequest extends GetHttpRequest {
  @override
  String get path => '/pokemon';

  @override
  Map<String, dynamic>? get queryParameters => {'limit': 1000};

  @override
  Map<String, String> get headers => {'Domain': 'acmesoftware.com'};
}
