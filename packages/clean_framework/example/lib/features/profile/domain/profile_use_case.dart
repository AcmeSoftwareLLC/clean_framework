import 'dart:math';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/profile/domain/profile_state.dart';
import 'package:clean_framework_example/features/profile/domain/profile_domain_outputs.dart';
import 'package:clean_framework_example/features/profile/external_interface/pokemon_profile_gateway.dart';
import 'package:clean_framework_example/features/profile/external_interface/pokemon_species_gateway.dart';

class ProfileUseCase extends UseCase<ProfileState> {
  ProfileUseCase(this.name)
      : super(
          entity: ProfileState(),
          transformers: [ProfileUIOutputTransformer()],
        );

  final String name;

  void fetchPokemonProfile() {
    final pokeName = name.toLowerCase();

    // If the use case is not auto disposed then we have last fetched data.
    if (!entity.description.isEmpty) return;

    request<PokemonSpeciesSuccessInput>(
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

    request<PokemonProfileSuccessInput>(
      PokemonProfileDomainToGatewayOutput(name: pokeName),
      onSuccess: (success) {
        final profile = success.profile;

        return entity.copyWith(
          name: name,
          types: profile.types,
          height: profile.height,
          weight: profile.weight,
          stats: profile.stats
              .map((s) => PokemonStatState(name: s.name, point: s.baseStat))
              .toList(growable: false),
        );
      },
      onFailure: (failure) => entity,
    );
  }
}

class ProfileUIOutputTransformer
    extends OutputTransformer<ProfileState, ProfileDomainToUIOutput> {
  @override
  ProfileDomainToUIOutput transform(ProfileState entity) {
    return ProfileDomainToUIOutput(
      types: entity.types,
      description: entity.description.replaceAll(RegExp(r'[\n\f]'), ' '),
      height: entity.height / 10,
      weight: entity.weight / 10,
      stats: entity.stats.map(
        (s) {
          return PokemonStat(
            name: _kebabToTitleCase(s.name),
            point: s.point,
          );
        },
      ).toList(growable: false),
    );
  }

  String _kebabToTitleCase(String input) {
    return input
        .replaceAll('special', 'sp.')
        .split('-')
        .map((s) => s[0].toUpperCase() + s.substring(1))
        .join(' ');
  }
}
