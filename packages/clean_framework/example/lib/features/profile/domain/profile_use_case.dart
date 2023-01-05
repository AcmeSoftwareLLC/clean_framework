import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/features/profile/domain/profile_entity.dart';
import 'package:clean_framework_example/features/profile/domain/profile_ui_output.dart';
import 'package:clean_framework_example/features/profile/external_interface/pokemon_profile_gateway.dart';

class ProfileUseCase extends UseCase<ProfileEntity> {
  ProfileUseCase()
      : super(
          entity: ProfileEntity(),
          transformers: [ProfileUIOutputTransformer()],
        );

  void fetchPokemonProfile(String name) {
    request<PokemonProfileGatewayOutput, PokemonProfileSuccessInput>(
      PokemonProfileGatewayOutput(name: name.toLowerCase()),
      onSuccess: (success) {
        print(success.profile);
        return entity;
      },
      onFailure: (failure) => entity,
    );
  }
}

class ProfileUIOutputTransformer
    extends OutputTransformer<ProfileEntity, ProfileUIOutput> {
  @override
  ProfileUIOutput transform(ProfileEntity entity) {
    return ProfileUIOutput();
  }
}
