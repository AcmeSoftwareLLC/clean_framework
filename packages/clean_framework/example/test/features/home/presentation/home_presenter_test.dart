import 'package:clean_framework_example_rest/features/home/domain/home_entity.dart';
import 'package:clean_framework_example_rest/features/home/domain/home_domain_models.dart';
import 'package:clean_framework_example_rest/features/home/domain/home_use_case.dart';
import 'package:clean_framework_example_rest/features/home/models/pokemon_model.dart';
import 'package:clean_framework_example_rest/features/home/presentation/home_presenter.dart';
import 'package:clean_framework_example_rest/features/home/presentation/home_view_model.dart';
import 'package:clean_framework_example_rest/providers.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(PokemonSearchDomainInput(name: ''));
  });

  group('HomePresenter tests |', () {
    presenterTest<HomeViewModel, HomeDomainToUIModel, HomeUseCase>(
      'creates proper view model',
      create: (builder) => HomePresenter(builder: builder),
      overrides: [
        homeUseCaseProvider.overrideWith(HomeUseCaseFake()),
      ],
      setup: (useCase) {
        useCase.debugEntityUpdate(
          (e) => e.copyWith(
            pokemons: [
              PokemonModel(name: 'Pikachu', imageUrl: ''),
              PokemonModel(name: 'Bulbasaur', imageUrl: ''),
            ],
          ),
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

    presenterTest<HomeViewModel, HomeDomainToUIModel, HomeUseCase>(
      'shows success snack bar if refreshing fails',
      create: (builder) => HomePresenter(builder: builder),
      overrides: [
        homeUseCaseProvider.overrideWith(HomeUseCaseFake()),
      ],
      setup: (useCase) {
        useCase.debugEntityUpdate(
          (e) => e.copyWith(
            isRefresh: true,
            status: HomeStatus.loaded,
          ),
        );
      },
      verify: (tester) {
        expect(
          find.text('Refreshed pokemons successfully!'),
          findsOneWidget,
        );
      },
    );

    presenterTest<HomeViewModel, HomeDomainToUIModel, HomeUseCase>(
      'shows failure snack bar if refreshing fails',
      create: (builder) => HomePresenter(builder: builder),
      overrides: [
        homeUseCaseProvider.overrideWith(HomeUseCaseFake()),
      ],
      setup: (useCase) {
        useCase.debugEntityUpdate(
          (e) => e.copyWith(
            isRefresh: true,
            status: HomeStatus.failed,
          ),
        );
      },
      verify: (tester) {
        expect(
          find.text('Sorry, failed refreshing pokemons!'),
          findsOneWidget,
        );
      },
    );

    presenterTest<HomeViewModel, HomeDomainToUIModel, HomeUseCase>(
      'shows failure snack bar if refreshing fails',
      create: (builder) => HomePresenter(builder: builder),
      overrides: [
        homeUseCaseProvider.overrideWith(HomeUseCaseFake()),
      ],
      setup: (useCase) {
        useCase.debugEntityUpdate(
          (e) => e.copyWith(
            isRefresh: true,
            status: HomeStatus.failed,
          ),
        );
      },
      verify: (tester) {
        expect(
          find.text('Sorry, failed refreshing pokemons!'),
          findsOneWidget,
        );
      },
    );

    presenterCallbackTest<HomeViewModel, HomeDomainToUIModel, HomeUseCase>(
      'calls refresh pokemon in use case',
      useCase: HomeUseCaseMock(),
      create: (builder) => HomePresenter(builder: builder),
      setup: (useCase) {
        when(() => useCase.fetchPokemons(isRefresh: true))
            .thenAnswer((_) async {});
      },
      verify: (useCase, vm) {
        vm.onRefresh();

        verify(() => useCase.fetchPokemons(isRefresh: true));
      },
    );

    presenterCallbackTest<HomeViewModel, HomeDomainToUIModel, HomeUseCase>(
      'sets search input on search',
      useCase: HomeUseCaseMock(),
      create: (builder) => HomePresenter(builder: builder),
      setup: (useCase) {
        when(() => useCase.setInput<PokemonSearchDomainInput>(any()))
            .thenAnswer((_) async {});
      },
      verify: (useCase, vm) {
        vm.onSearch('pikachu');

        final input = verify(
          () => useCase.setInput<PokemonSearchDomainInput>(captureAny()),
        ).captured.last as PokemonSearchDomainInput;

        expect(input.name, equals('pikachu'));
      },
    );
  });
}

class HomeUseCaseFake extends HomeUseCase {
  @override
  Future<void> fetchPokemons({bool isRefresh = false}) async {}
}

class HomeUseCaseMock extends UseCaseMock<HomeEntity> implements HomeUseCase {
  HomeUseCaseMock()
      : super(
          entity: HomeEntity(),
          transformers: [HomeDomainToUIModelTransformer()],
        );
}
