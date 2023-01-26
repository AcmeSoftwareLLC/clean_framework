import 'package:clean_framework_example/features/home/models/pokemon_model.dart';
import 'package:clean_framework_example/features/home/presentation/home_ui.dart';
import 'package:clean_framework_example/features/home/presentation/home_view_model.dart';
import 'package:clean_framework_example/routing/routes.dart';
import 'package:clean_framework_example/widgets/cache_manager_scope.dart';
import 'package:clean_framework_example/widgets/pokemon_card.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_cache_manager.dart';

void main() {
  group('HomeUI tests |', () {
    uiTest(
      'shows pokemon list correctly',
      ui: HomeUI(),
      viewModel: HomeViewModel(
        pokemons: [
          PokemonModel(name: 'Pikachu', imageUrl: ''),
          PokemonModel(name: 'Bulbasaur', imageUrl: ''),
        ],
        isLoading: false,
        hasFailedLoading: false,
        lastViewedPokemon: '',
        onRetry: () {},
        onRefresh: () async {},
        onSearch: (query) {},
      ),
      verify: (tester) async {
        expect(find.text('Pikachu'), findsOneWidget);
        expect(find.text('Bulbasaur'), findsOneWidget);
      },
    );

    uiTest(
      'shows loading indicator if loading data',
      ui: HomeUI(),
      viewModel: HomeViewModel(
        pokemons: [],
        isLoading: true,
        hasFailedLoading: false,
        lastViewedPokemon: '',
        onRetry: () {},
        onRefresh: () async {},
        onSearch: (query) {},
      ),
      verify: (tester) async {
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    uiTest(
      'shows loading failed widget if data failed loading',
      ui: HomeUI(),
      viewModel: HomeViewModel(
        pokemons: [],
        isLoading: false,
        hasFailedLoading: true,
        lastViewedPokemon: '',
        onRetry: () {},
        onRefresh: () async {},
        onSearch: (query) {},
      ),
      verify: (tester) async {
        expect(find.text('Oops'), findsOneWidget);
        expect(find.text('I lost my fellow Pokémons'), findsOneWidget);
        expect(find.text('Help Flareon, find her friends'), findsOneWidget);
      },
    );

    uiTest(
      'shows last viewed pokemon if there is one',
      ui: HomeUI(),
      viewModel: HomeViewModel(
        pokemons: [
          PokemonModel(name: 'Pikachu', imageUrl: ''),
        ],
        isLoading: false,
        hasFailedLoading: false,
        lastViewedPokemon: 'Charmander',
        onRetry: () {},
        onRefresh: () async {},
        onSearch: (query) {},
      ),
      verify: (tester) async {
        expect(find.text('Last Viewed: Charmander'), findsOneWidget);
      },
    );

    uiTest(
      'tapping on pokemon navigates to detail page',
      builder: (context, child) {
        return CacheManagerScope(
          cacheManager: TestCacheManager(),
          child: child,
        );
      },
      ui: HomeUI(),
      viewModel: HomeViewModel(
        pokemons: [
          PokemonModel(name: 'Pikachu', imageUrl: ''),
          PokemonModel(name: 'Bulbasaur', imageUrl: ''),
        ],
        isLoading: false,
        hasFailedLoading: false,
        lastViewedPokemon: 'Charmander',
        onRetry: () {},
        onRefresh: () async {},
        onSearch: (query) {},
      ),
      verify: (tester) async {
        await tester.pumpAndSettle();

        final pikachuCardFinder = find.descendant(
          of: find.byType(PokemonCard),
          matching: find.text('Pikachu'),
        );

        expect(pikachuCardFinder, findsOneWidget);

        await tester.tap(pikachuCardFinder);
        await tester.pumpAndSettle();

        final routeData = tester.routeData!;
        expect(routeData.route, Routes.profile);
        expect(routeData.params, equals({'pokemon_name': 'Pikachu'}));
      },
    );
  });
}
