import 'package:clean_framework_example_rest/features/home/models/pokemon_model.dart';
import 'package:clean_framework_example_rest/features/home/presentation/home_ui.dart';
import 'package:clean_framework_example_rest/features/home/presentation/home_view_model.dart';
import 'package:clean_framework_example_rest/routing/routes.dart';
import 'package:clean_framework_example_rest/widgets/app_scope.dart';
import 'package:clean_framework_example_rest/widgets/pokemon_card.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palette_generator/palette_generator.dart';

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
        loggedInEmail: '',
        onRetry: () {},
        onRefresh: () async {},
        onSearch: (query) {},
        errorMessage: '',
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
        loggedInEmail: '',
        onRetry: () {},
        onRefresh: () async {},
        onSearch: (query) {},
        errorMessage: '',
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
        loggedInEmail: '',
        onRetry: () {},
        onRefresh: () async {},
        onSearch: (query) {},
        errorMessage: '',
      ),
      verify: (tester) async {
        expect(find.text('Oops'), findsOneWidget);
        expect(find.text('I lost my fellow Pokémons'), findsOneWidget);
        expect(find.text('Help Flareon, find her friends'), findsOneWidget);
      },
    );

    uiTest(
      'tapping on pokemon navigates to detail page',
      builder: (context, child) {
        return AppScope(
          cacheManager: TestCacheManager(),
          paletteGenerator: PaletteGenerator.fromColors(
            [
              PaletteColor(Colors.red, 3),
              PaletteColor(Colors.green, 2),
              PaletteColor(Colors.blue, 1),
            ],
          ),
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
        loggedInEmail: 'Charmander',
        onRetry: () {},
        onRefresh: () async {},
        onSearch: (query) {},
        errorMessage: '',
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

        tester.element(find.byType(MaterialApp)).router.pop();
        await tester.pumpAndSettle();

        final poppedRouteData = tester.poppedRouteData!;
        expect(poppedRouteData.route, Routes.profile);
        expect(poppedRouteData.params, equals({'pokemon_name': 'Pikachu'}));
      },
    );
  });
}
