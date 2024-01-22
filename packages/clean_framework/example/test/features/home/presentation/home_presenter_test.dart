import 'package:clean_framework_example/features/home/domain/home_state.dart';
import 'package:clean_framework_example/features/home/domain/home_domain_outputs.dart';
import 'package:clean_framework_example/features/home/domain/home_use_case.dart';
import 'package:clean_framework_example/features/home/models/pokemon_model.dart';
import 'package:clean_framework_example/features/home/presentation/home_presenter.dart';
import 'package:clean_framework_example/features/home/presentation/home_view_model.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(PokemonSearchDomainInput(name: ''));
  });

  group('HomePresenter tests |', () {
    presenterTest<HomeViewModel, HomeDomainToUIOutput, HomeUseCase>(
      'creates proper view model',
      create: (builder) => HomePresenter(builder: builder),
      overrides: [
        homeUseCaseProvider.overrideWith(HomeUseCaseFake()),
      ],
      setup: (useCase) {
        useCase.debugUseCaseStateUpdate(
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

    presenterTest<HomeViewModel, HomeDomainToUIOutput, HomeUseCase>(
      'shows success snack bar if refreshing fails',
      create: (builder) => HomePresenter(builder: builder),
      overrides: [
        homeUseCaseProvider.overrideWith(HomeUseCaseFake()),
      ],
      setup: (useCase) {
        useCase.debugUseCaseStateUpdate(
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

    presenterTest<HomeViewModel, HomeDomainToUIOutput, HomeUseCase>(
      'shows failure snack bar if refreshing fails',
      create: (builder) => HomePresenter(builder: builder),
      overrides: [
        homeUseCaseProvider.overrideWith(HomeUseCaseFake()),
      ],
      setup: (useCase) {
        useCase.debugUseCaseStateUpdate(
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

    presenterTest<HomeViewModel, HomeDomainToUIOutput, HomeUseCase>(
      'shows failure snack bar if refreshing fails',
      create: (builder) => HomePresenter(builder: builder),
      overrides: [
        homeUseCaseProvider.overrideWith(HomeUseCaseFake()),
      ],
      setup: (useCase) {
        useCase.debugUseCaseStateUpdate(
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

    presenterCallbackTest<HomeViewModel, HomeDomainToUIOutput, HomeUseCase>(
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

    presenterCallbackTest<HomeViewModel, HomeDomainToUIOutput, HomeUseCase>(
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

class HomeUseCaseMock extends UseCaseMock<HomeState> implements HomeUseCase {
  HomeUseCaseMock()
      : super(
          entity: HomeState(),
          transformers: [HomeDomainToUIOutputTransformer()],
        );
}
