import 'package:clean_framework_example/features/profile/domain/profile_ui_output.dart';
import 'package:clean_framework_example/features/profile/domain/profile_use_case.dart';
import 'package:clean_framework_example/features/profile/models/pokemon_profile_model.dart';
import 'package:clean_framework_example/features/profile/presentation/profile_presenter.dart';
import 'package:clean_framework_example/features/profile/presentation/profile_view_model.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfilePresenter tests |', () {
    presenterTest<ProfileViewModel, ProfileUIOutput, ProfileUseCase>(
      'creates proper view model',
      create: (builder) => ProfilePresenter(
        builder: builder,
        name: 'pikachu',
      ),
      overrides: [
        profileUseCaseProvider.overrideWith(ProfileUseCaseFake()),
      ],
      setup: (useCase) {
        useCase.entity = useCase.entity.copyWith(
          name: 'Pikachu',
          description: 'Pikachu is a small, chubby rodent Pokémon.',
          height: 4,
          weight: 60,
          stats: [
            PokemonStatModel(name: 'hp', baseStat: 35),
            PokemonStatModel(name: 'attack', baseStat: 55),
            PokemonStatModel(name: 'defense', baseStat: 40),
            PokemonStatModel(name: 'special-attack', baseStat: 50),
            PokemonStatModel(name: 'special-defense', baseStat: 50),
            PokemonStatModel(name: 'speed', baseStat: 90),
          ],
          types: ['electric'],
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
  @override
  void fetchPokemonProfile(String name) {}
}
