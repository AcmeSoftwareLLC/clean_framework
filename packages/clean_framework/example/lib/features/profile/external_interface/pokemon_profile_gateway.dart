import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_request.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_success_response.dart';
import 'package:clean_framework_example/features/profile/external_interface/pokemon_profile_model.dart';

class PokemonProfileGateway extends Gateway<PokemonProfileGatewayOutput,
    PokemonProfileRequest, PokemonSuccessResponse, PokemonProfileSuccessInput> {
  @override
  PokemonProfileRequest buildRequest(PokemonProfileGatewayOutput output) {
    return PokemonProfileRequest(name: output.name);
  }

  @override
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput(message: failureResponse.message);
  }

  @override
  PokemonProfileSuccessInput onSuccess(PokemonSuccessResponse response) {
    return PokemonProfileSuccessInput(
      profile: PokemonProfileModel.fromJson(response.data),
    );
  }
}

class PokemonProfileGatewayOutput extends Output {
  PokemonProfileGatewayOutput({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}

class PokemonProfileSuccessInput extends SuccessInput {
  PokemonProfileSuccessInput({required this.profile});

  final PokemonProfileModel profile;
}

class PokemonProfileRequest extends GetPokemonRequest {
  PokemonProfileRequest({required this.name});

  final String name;

  @override
  String get resource => 'pokemon/$name';
}
