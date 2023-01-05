import 'dart:math';

import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/features/profile/domain/profile_entity.dart';
import 'package:clean_framework_example/features/profile/domain/profile_ui_output.dart';
import 'package:clean_framework_example/features/profile/external_interface/pokemon_profile_gateway.dart';
import 'package:clean_framework_example/features/profile/external_interface/pokemon_species_gateway.dart';

class ProfileUseCase extends UseCase<ProfileEntity> {
  ProfileUseCase()
      : super(
          entity: ProfileEntity(),
          transformers: [ProfileUIOutputTransformer()],
        );

  void fetchPokemonProfile(String name) {
    final pokeName = name.toLowerCase();

    request<PokemonSpeciesGatewayOutput, PokemonSpeciesSuccessInput>(
      PokemonSpeciesGatewayOutput(name: pokeName),
      onSuccess: (success) {
        final descriptions = success.species.descriptions.where(
          (desc) => desc.language == 'en',
        );

        final randomIndex = Random().nextInt(descriptions.length);

        return entity.copyWith(
          description: descriptions.elementAt(randomIndex).text,
        );
      },
      onFailure: (failure) => entity,
    );

    request<PokemonProfileGatewayOutput, PokemonProfileSuccessInput>(
      PokemonProfileGatewayOutput(name: pokeName),
      onSuccess: (success) {
        final profile = success.profile;

        return entity.copyWith(
          types: profile.types,
          height: profile.height,
          weight: profile.weight,
        );
      },
      onFailure: (failure) => entity,
    );
  }
}

class ProfileUIOutputTransformer
    extends OutputTransformer<ProfileEntity, ProfileUIOutput> {
  @override
  ProfileUIOutput transform(ProfileEntity entity) {
    return ProfileUIOutput(
      types: entity.types,
      description: entity.description,
      height: entity.height / 10,
      weight: entity.weight / 10,
    );
  }
}
