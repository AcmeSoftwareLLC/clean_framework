import 'package:clean_framework_example_rest/widgets/app_scope.dart';
import 'package:clean_framework_example_rest/widgets/svg_palette_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palette_generator/palette_generator.dart';

import '../helpers/test_cache_manager.dart';

void main() {
  testWidgets('SVGPaletteCard', (tester) async {
    await tester.pumpWidget(
      AppScope(
        paletteGenerator: PaletteGenerator.fromColors(
          [PaletteColor(const Color(0xFFFF0000), 100)],
        ),
        cacheManager: TestCacheManager(),
        child: MaterialApp(
          home: SvgPaletteCard(
            url: '',
            builder: (context, picture) {
              return const Text('Palette Card');
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final cardMaterialFinder = find.descendant(
      of: find.byType(Card),
      matching: find.byType(Material),
    );

    var material = tester.widget<Material>(cardMaterialFinder);
    expect(material.color, equals(const Color(0xFFFF0000)));

    await tester.pumpWidget(
      AppScope(
        paletteGenerator: PaletteGenerator.fromColors(
          [
            PaletteColor(const Color(0xFF00FF00), 100), // Green
            PaletteColor(const Color(0xFF0000FF), 50), // Blue
          ],
        ),
        cacheManager: TestCacheManager(),
        child: MaterialApp(
          home: SvgPaletteCard(
            url: 'test',
            builder: (context, picture) {
              return const Text('Palette Card');
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    material = tester.widget<Material>(cardMaterialFinder);
    expect(
      material.color,
      equals(const Color(0xFF00FF00)), // Since Green is dominant,
      // as it has pop. of 100.
    );
  });
}
