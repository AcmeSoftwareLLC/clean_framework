import 'package:clean_framework_example/features/profile/domain/profile_entity.dart';
import 'package:clean_framework_example/features/profile/presentation/profile_ui.dart';
import 'package:clean_framework_example/features/profile/presentation/profile_view_model.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_cache_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProfileUI tests |', () {
    uiTest(
      'shows pokemon profile correctly',
      overrides: [
        cacheManagerProvider.overrideWithValue(TestCacheManager()),
      ],
      ui: ProfileUI(pokemonName: 'Pikachu', pokemonImageUrl: 'test'),
      viewModel: ProfileViewModel(
        description: 'Pikachu is a small, chubby rodent Pokémon.',
        height: '4',
        weight: '60',
        pokemonTypes: [PokemonType('electric')],
        stats: [
          PokemonStat(name: 'hp', point: 35),
          PokemonStat(name: 'attack', point: 55),
          PokemonStat(name: 'defense', point: 40),
          PokemonStat(name: 'special-attack', point: 50),
          PokemonStat(name: 'special-defense', point: 50),
          PokemonStat(name: 'speed', point: 90),
        ],
      ),
      verify: (tester) async {
        await tester.pumpAndSettle();

        expect(find.text('Pikachu'), findsOneWidget);
      },
    );
  });
}
