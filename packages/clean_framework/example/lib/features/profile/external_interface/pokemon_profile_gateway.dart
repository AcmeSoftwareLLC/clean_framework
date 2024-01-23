import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_request.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_success_response.dart';
import 'package:clean_framework_example/features/profile/domain/profile_domain_models.dart';
import 'package:clean_framework_example/features/profile/models/pokemon_profile_model.dart';

class PokemonProfileGateway extends Gateway<PokemonProfileDomainToGatewayModel,
    PokemonProfileRequest, PokemonSuccessResponse, PokemonProfileSuccessInput> {
  @override
  PokemonProfileRequest buildRequest(
      PokemonProfileDomainToGatewayModel output) {
    return PokemonProfileRequest(name: output.name);
  }

  @override
  FailureDomainInput onFailure(FailureResponse failureResponse) {
    return FailureDomainInput(message: failureResponse.message);
  }

  @override
  PokemonProfileSuccessInput onSuccess(PokemonSuccessResponse response) {
    return PokemonProfileSuccessInput(
      profile: PokemonProfileModel.fromJson(response.data),
    );
  }
}

class PokemonProfileSuccessInput extends SuccessDomainInput {
  PokemonProfileSuccessInput({required this.profile});

  final PokemonProfileModel profile;
}

class PokemonProfileRequest extends GetPokemonRequest {
  PokemonProfileRequest({required this.name});

  final String name;

  @override
  String get resource => 'pokemon/$name';
}
