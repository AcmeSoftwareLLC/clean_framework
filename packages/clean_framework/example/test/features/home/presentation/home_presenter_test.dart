import 'package:clean_framework_example/features/home/domain/home_entity.dart';
import 'package:clean_framework_example/features/home/domain/home_ui_output.dart';
import 'package:clean_framework_example/features/home/domain/home_use_case.dart';
import 'package:clean_framework_example/features/home/models/pokemon_model.dart';
import 'package:clean_framework_example/features/home/presentation/home_presenter.dart';
import 'package:clean_framework_example/features/home/presentation/home_view_model.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomePresenter tests |', () {
    presenterTest<HomeViewModel, HomeUIOutput, HomeUseCase>(
      'creates proper view model',
      create: (builder) => HomePresenter(builder: builder),
      overrides: [
        homeUseCaseProvider.overrideWith(HomeUseCaseMock()),
      ],
      setup: (useCase) {
        useCase.entity = useCase.entity.copyWith(
          pokemons: [
            PokemonModel(name: 'Pikachu', imageUrl: ''),
            PokemonModel(name: 'Bulbasaur', imageUrl: ''),
          ],
        );
      },
      expect: () => [
        isA<HomeViewModel>().having((vm) => vm.pokemons, 'pokemons', []),
        isA<HomeViewModel>().having(
          (vm) => vm.pokemons.map((p) => p.name),
          'pokemons',
          ['Pikachu', 'Bulbasaur'],
        ),
      ],
    );

    presenterTest<HomeViewModel, HomeUIOutput, HomeUseCase>(
      'shows success snack bar if refreshing fails',
      create: (builder) => HomePresenter(builder: builder),
      overrides: [
        homeUseCaseProvider.overrideWith(HomeUseCaseMock()),
      ],
      setup: (useCase) {
        useCase.entity = useCase.entity.copyWith(
          isRefresh: true,
          status: HomeStatus.loaded,
        );
      },
      verify: (tester) async {
        expect(
          find.text('Refreshed pokemons successfully!'),
          findsOneWidget,
        );
      },
    );

    presenterTest<HomeViewModel, HomeUIOutput, HomeUseCase>(
      'shows failure snack bar if refreshing fails',
      create: (builder) => HomePresenter(builder: builder),
      overrides: [
        homeUseCaseProvider.overrideWith(HomeUseCaseMock()),
      ],
      setup: (useCase) {
        useCase.entity = useCase.entity.copyWith(
          isRefresh: true,
          status: HomeStatus.failed,
        );
      },
      verify: (tester) async {
        expect(
          find.text('Sorry, failed refreshing pokemons!'),
          findsOneWidget,
        );
      },
    );
  });
}

class HomeUseCaseMock extends HomeUseCase {
  @override
  Future<void> fetchPokemons({bool isRefresh = false}) async {}
}
