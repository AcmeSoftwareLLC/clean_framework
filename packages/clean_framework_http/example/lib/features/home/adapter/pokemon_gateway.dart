import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_http/clean_framework_http.dart';
import 'package:clean_framework_http_example/features/home/adapter/pokemon_model.dart';

class PokemonGateway extends Gateway<PokemonGatewayOutput, PokemonRequest,
    SuccessResponse, PokemonSuccessInput> {
  @override
  PokemonRequest buildRequest(PokemonGatewayOutput output) {
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

class PokemonGatewayOutput extends DomainOutput {
  @override
  List<Object?> get props => [];
}

class PokemonSuccessInput extends SuccessDomainInput {
  const PokemonSuccessInput({required this.pokemons});

  final List<PokemonModel> pokemons;
}

class PokemonRequest extends GetHttpRequest {
  @override
  String get path => '/pokemon';

  @override
  Map<String, dynamic>? get queryParameters => {'limit': 1000};

  @override
  Map<String, String> get headers => {'Domain': 'acmesoftware.com'};
}
