import 'package:clean_framework_example_rest/widgets/app_scope.dart';
import 'package:clean_framework_example_rest/widgets/pokemon_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palette_generator/palette_generator.dart';

import '../helpers/test_cache_manager.dart';

void main() {
  testWidgets('PokemonCard test', (tester) async {
    await tester.pumpWidget(
      AppScope(
        paletteGenerator: PaletteGenerator.fromColors(
          [PaletteColor(Color(0xFFFF0000), 100)],
        ),
        cacheManager: TestCacheManager(),
        child: MaterialApp(
          theme: ThemeData(primaryColor: Colors.red).copyWith(
            brightness: Brightness.dark,
          ),
          home: PokemonCard(
            imageUrl: 'test',
            name: 'test',
            heroTag: 'test',
            onTap: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final cardMaterialFinder = find.descendant(
      of: find.byType(Card),
      matching: find.byType(Material),
    );

    Material material = tester.widget<Material>(cardMaterialFinder);
    expect(material.color, equals(Color(0xFFFF0000)));
  });
}
