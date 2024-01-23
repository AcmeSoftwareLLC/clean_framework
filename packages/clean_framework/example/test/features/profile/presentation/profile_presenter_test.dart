import 'package:clean_framework_example/features/profile/domain/profile_state.dart';
import 'package:clean_framework_example/features/profile/domain/profile_domain_outputs.dart';
import 'package:clean_framework_example/features/profile/domain/profile_use_case.dart';
import 'package:clean_framework_example/features/profile/presentation/profile_presenter.dart';
import 'package:clean_framework_example/features/profile/presentation/profile_view_model.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfilePresenter tests |', () {
    presenterTest<ProfileViewModel, ProfileDomainToUIOutput, ProfileUseCase>(
      'creates proper view model',
      create: (builder) => ProfilePresenter(
        builder: builder,
        name: 'pikachu',
      ),
      overrides: [
        profileUseCaseFamily('PIKACHU')
            .overrideWith(ProfileUseCaseFake('PIKACHU')),
      ],
      setup: (useCase) {
        useCase.debugEntityUpdate(
          (e) => e.copyWith(
            name: 'Pikachu',
            description: 'Pikachu is a small, chubby rodent Pokémon.',
            height: 4,
            weight: 60,
            stats: [
              PokemonStatState(name: 'hp', point: 35),
              PokemonStatState(name: 'attack', point: 55),
              PokemonStatState(name: 'defense', point: 40),
              PokemonStatState(name: 'special-attack', point: 50),
              PokemonStatState(name: 'special-defense', point: 50),
              PokemonStatState(name: 'speed', point: 90),
            ],
            types: ['electric'],
          ),
        );
      },
      expect: () => [
        isA<ProfileViewModel>()
            .having((vm) => vm.description, 'description', ''),
        isA<ProfileViewModel>().having((vm) => vm.description, 'description',
            'Pikachu is a small, chubby rodent Pokémon.'),
      ],
    );
  });
}

class ProfileUseCaseFake extends ProfileUseCase {
  ProfileUseCaseFake(super.name);

  @override
  void fetchPokemonProfile() {}
}
