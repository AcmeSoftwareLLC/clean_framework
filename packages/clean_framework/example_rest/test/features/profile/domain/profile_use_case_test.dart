import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/features/profile/domain/profile_domain_inputs.dart';
import 'package:clean_framework_example_rest/features/profile/domain/profile_entity.dart';
import 'package:clean_framework_example_rest/features/profile/domain/profile_domain_models.dart';
import 'package:clean_framework_example_rest/features/profile/domain/profile_use_case.dart';
import 'package:clean_framework_example_rest/features/profile/models/pokemon_profile_model.dart';
import 'package:clean_framework_example_rest/features/profile/models/pokemon_species_model.dart';
import 'package:clean_framework_example_rest/providers.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileUseCase tests |', () {
    useCaseTest<ProfileUseCase, ProfileEntity, ProfileDomainToUIModel>(
      'fetches pokemon profile',
      provider: profileUseCaseFamily('pikachu'),
      execute: (useCase) {
        useCase.subscribe<PokemonSpeciesDomainToGatewayModel,
            PokemonSpeciesSuccessDomainInput>(
          (output) {
            return Either.right(
              PokemonSpeciesSuccessDomainInput(
                species: PokemonSpeciesModel(
                  descriptions: [
                    PokemonDescriptionModel(
                      language: 'en',
                      text: 'At will, it can generate powerful electricity.',
                    ),
                  ],
                ),
              ),
            );
          },
        );

        useCase.subscribe<PokemonProfileDomainToGatewayModel,
            PokemonProfileSuccessInput>(
          (output) {
            return Either.right(
              PokemonProfileSuccessInput(
                profile: PokemonProfileModel(
                  types: ['electric'],
                  height: 4,
                  weight: 60,
                  baseExperience: 112,
                  stats: [
                    PokemonStatModel(name: 'hp', baseStat: 35),
                    PokemonStatModel(name: 'attack', baseStat: 55),
                    PokemonStatModel(name: 'defense', baseStat: 40),
                    PokemonStatModel(name: 'special-attack', baseStat: 50),
                    PokemonStatModel(name: 'special-defense', baseStat: 50),
                    PokemonStatModel(name: 'speed', baseStat: 90),
                  ],
                ),
              ),
            );
          },
        );

        useCase.fetchPokemonProfile();
      },
      expect: () => [
        ProfileDomainToUIModel(
          types: [],
          description: 'At will, it can generate powerful electricity.',
          height: 0,
          weight: 0,
          stats: [],
        ),
        ProfileDomainToUIModel(
          types: ['electric'],
          description: 'At will, it can generate powerful electricity.',
          height: 0.4,
          weight: 6.0,
          stats: [
            PokemonStat(name: 'Hp', point: 35),
            PokemonStat(name: 'Attack', point: 55),
            PokemonStat(name: 'Defense', point: 40),
            PokemonStat(name: 'Sp. Attack', point: 50),
            PokemonStat(name: 'Sp. Defense', point: 50),
            PokemonStat(name: 'Speed', point: 90),
          ],
        ),
      ],
    );

    useCaseTest<ProfileUseCase, ProfileEntity, ProfileDomainToUIModel>(
      'fetches pokemon profile; description failure',
      provider: profileUseCaseFamily('PIKACHU'),
      execute: (useCase) {
        useCase.subscribe<PokemonSpeciesDomainToGatewayModel,
            PokemonSpeciesSuccessDomainInput>(
          (output) {
            return Either.left(
                FailureDomainInput(message: 'Something went wrong'));
          },
        );

        useCase.subscribe<PokemonProfileDomainToGatewayModel,
            PokemonProfileSuccessInput>(
          (output) {
            return Either.right(
              PokemonProfileSuccessInput(
                profile: PokemonProfileModel(
                  types: ['electric'],
                  height: 4,
                  weight: 60,
                  baseExperience: 112,
                  stats: [
                    PokemonStatModel(name: 'hp', baseStat: 35),
                    PokemonStatModel(name: 'attack', baseStat: 55),
                    PokemonStatModel(name: 'defense', baseStat: 40),
                    PokemonStatModel(name: 'special-attack', baseStat: 50),
                    PokemonStatModel(name: 'special-defense', baseStat: 50),
                    PokemonStatModel(name: 'speed', baseStat: 90),
                  ],
                ),
              ),
            );
          },
        );

        useCase.fetchPokemonProfile();
      },
      expect: () => [
        ProfileDomainToUIModel(
          types: ['electric'],
          description: '',
          height: 0.4,
          weight: 6.0,
          stats: [
            PokemonStat(name: 'Hp', point: 35),
            PokemonStat(name: 'Attack', point: 55),
            PokemonStat(name: 'Defense', point: 40),
            PokemonStat(name: 'Sp. Attack', point: 50),
            PokemonStat(name: 'Sp. Defense', point: 50),
            PokemonStat(name: 'Speed', point: 90),
          ],
        ),
      ],
    );

    useCaseTest<ProfileUseCase, ProfileEntity, ProfileDomainToUIModel>(
      'fetches pokemon profile; profile/stat failure',
      provider: profileUseCaseFamily('PIKACHU'),
      execute: (useCase) {
        useCase.subscribe<PokemonSpeciesDomainToGatewayModel,
            PokemonSpeciesSuccessDomainInput>(
          (output) {
            return Either.right(
              PokemonSpeciesSuccessDomainInput(
                species: PokemonSpeciesModel(
                  descriptions: [
                    PokemonDescriptionModel(
                      language: 'en',
                      text: 'At will, it can generate powerful electricity.',
                    ),
                  ],
                ),
              ),
            );
          },
        );

        useCase.subscribe<PokemonProfileDomainToGatewayModel,
            PokemonProfileSuccessInput>(
          (output) {
            return Either.left(
                FailureDomainInput(message: 'Something went wrong'));
          },
        );

        useCase.fetchPokemonProfile();
      },
      expect: () => [
        ProfileDomainToUIModel(
          types: [],
          description: 'At will, it can generate powerful electricity.',
          height: 0,
          weight: 0,
          stats: [],
        ),
      ],
    );
  });
}
