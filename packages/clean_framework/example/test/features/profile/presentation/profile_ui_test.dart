import 'package:clean_framework_example_rest/features/profile/domain/profile_domain_models.dart';
import 'package:clean_framework_example_rest/features/profile/presentation/profile_ui.dart';
import 'package:clean_framework_example_rest/features/profile/presentation/profile_view_model.dart';
import 'package:clean_framework_example_rest/widgets/app_scope.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../helpers/test_cache_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProfileUI tests |', () {
    uiTest(
      'shows pokemon profile correctly',
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
      ui: ProfileUI(pokemonName: 'PIKACHU', pokemonImageUrl: 'test'),
      viewModel: ProfileViewModel(
        description: 'Pikachu is a small, chubby rodent Pokémon.',
        height: '0.4 m',
        weight: '6.0 kg',
        pokemonTypes: [PokemonType('electric')],
        stats: [
          PokemonStat(name: 'Hp', point: 35),
          PokemonStat(name: 'Attack', point: 55),
          PokemonStat(name: 'Defense', point: 40),
          PokemonStat(name: 'Sp. Attack', point: 50),
          PokemonStat(name: 'Sp. Defense', point: 50),
          PokemonStat(name: 'Speed', point: 90),
        ],
      ),
      verify: (tester) async {
        await tester.pumpAndSettle();

        expect(find.text('PIKACHU'), findsOneWidget);

        expect(find.text('electric'), findsOneWidget);

        expect(
          find.text('Pikachu is a small, chubby rodent Pokémon.'),
          findsOneWidget,
        );

        expect(find.text('6.0 kg'), findsOneWidget);
        expect(find.text('0.4 m'), findsOneWidget);

        _expectStat(name: 'Hp', point: '35');
        _expectStat(name: 'Attack', point: '55');
        _expectStat(name: 'Defense', point: '40');
        _expectStat(name: 'Sp. Attack', point: '50');
        _expectStat(name: 'Sp. Defense', point: '50');
        _expectStat(name: 'Speed', point: '90');
      },
    );
  });
}

void _expectStat({required String name, required String point}) {
  final statNameFinder = find.text(name);
  expect(statNameFinder, findsOneWidget);

  final statRowFinder = find.ancestor(
    of: statNameFinder,
    matching: find.byType(Row),
  );

  final statPointFinder = find.descendant(
    of: statRowFinder,
    matching: find.text(point),
  );
  expect(statPointFinder, findsOneWidget);
}
