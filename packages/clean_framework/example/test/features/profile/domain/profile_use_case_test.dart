import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/profile/domain/profile_entity.dart';
import 'package:clean_framework_example/features/profile/domain/profile_ui_output.dart';
import 'package:clean_framework_example/features/profile/domain/profile_use_case.dart';
import 'package:clean_framework_example/features/profile/external_interface/pokemon_profile_gateway.dart';
import 'package:clean_framework_example/features/profile/external_interface/pokemon_species_gateway.dart';
import 'package:clean_framework_example/features/profile/models/pokemon_profile_model.dart';
import 'package:clean_framework_example/features/profile/models/pokemon_species_model.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileUseCase tests |', () {
    useCaseTest<ProfileUseCase, ProfileEntity, ProfileUIOutput>(
      'fetches pokemon profile',
      provider: profileUseCaseFamily('pikachu'),
      execute: (useCase) {
        useCase
            .subscribe<PokemonSpeciesGatewayOutput, PokemonSpeciesSuccessInput>(
          (output) {
            return Either.right(
              PokemonSpeciesSuccessInput(
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

        useCase
            .subscribe<PokemonProfileGatewayOutput, PokemonProfileSuccessInput>(
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
        ProfileUIOutput(
          types: [],
          description: 'At will, it can generate powerful electricity.',
          height: 0,
          weight: 0,
          stats: [],
        ),
        ProfileUIOutput(
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
      verify: (useCase) {
        expect(
          useCase.debugEntity,
          ProfileEntity(
            name: 'pikachu',
            description: 'At will, it can generate powerful electricity.',
            height: 4,
            weight: 60,
            stats: [
              PokemonStatEntity(name: 'hp', point: 35),
              PokemonStatEntity(name: 'attack', point: 55),
              PokemonStatEntity(name: 'defense', point: 40),
              PokemonStatEntity(name: 'special-attack', point: 50),
              PokemonStatEntity(name: 'special-defense', point: 50),
              PokemonStatEntity(name: 'speed', point: 90),
            ],
            types: ['electric'],
          ),
        );
      },
    );

    useCaseTest<ProfileUseCase, ProfileEntity, ProfileUIOutput>(
      'fetches pokemon profile; description failure',
      provider: profileUseCaseFamily('PIKACHU'),
      execute: (useCase) {
        useCase
            .subscribe<PokemonSpeciesGatewayOutput, PokemonSpeciesSuccessInput>(
          (output) {
            return Either.left(FailureInput(message: 'Something went wrong'));
          },
        );

        useCase
            .subscribe<PokemonProfileGatewayOutput, PokemonProfileSuccessInput>(
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
        ProfileUIOutput(
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

    useCaseTest<ProfileUseCase, ProfileEntity, ProfileUIOutput>(
      'fetches pokemon profile; profile/stat failure',
      provider: profileUseCaseFamily('PIKACHU'),
      execute: (useCase) {
        useCase
            .subscribe<PokemonSpeciesGatewayOutput, PokemonSpeciesSuccessInput>(
          (output) {
            return Either.right(
              PokemonSpeciesSuccessInput(
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

        useCase
            .subscribe<PokemonProfileGatewayOutput, PokemonProfileSuccessInput>(
          (output) {
            return Either.left(FailureInput(message: 'Something went wrong'));
          },
        );

        useCase.fetchPokemonProfile();
      },
      expect: () => [
        ProfileUIOutput(
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
