import 'dart:math';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/features/profile/domain/profile_domain_inputs.dart';
import 'package:clean_framework_example_rest/features/profile/domain/profile_entity.dart';
import 'package:clean_framework_example_rest/features/profile/domain/profile_domain_models.dart';

class ProfileUseCase extends UseCase<ProfileEntity> {
  ProfileUseCase(this.name)
      : super(
          entity: ProfileEntity(),
          transformers: [
            ProfileDomainToUIModelTransformer(),
          ],
        );

  final String name;

  void fetchPokemonProfile() {
    final pokeName = name.toLowerCase();

    // If the use case is not auto disposed then we have last fetched data.
    if (!entity.description.isEmpty) return;

    request<PokemonSpeciesSuccessDomainInput>(
      PokemonSpeciesDomainToGatewayModel(name: pokeName),
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
      PokemonProfileDomainToGatewayModel(name: pokeName),
      onSuccess: (success) {
        final profile = success.profile;

        return entity.copyWith(
          name: name,
          types: profile.types,
          height: profile.height,
          weight: profile.weight,
          stats: profile.stats
              .map((s) => ProfileStatEntity(name: s.name, point: s.baseStat))
              .toList(growable: false),
        );
      },
      onFailure: (failure) => entity,
    );
  }
}

class ProfileDomainToUIModelTransformer
    extends DomainModelTransformer<ProfileEntity, ProfileDomainToUIModel> {
  @override
  ProfileDomainToUIModel transform(ProfileEntity entity) {
    return ProfileDomainToUIModel(
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
