import 'package:clean_framework_example_rest/widgets/app_scope.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palette_generator/palette_generator.dart';

import '../helpers/test_cache_manager.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final image = await decodeImageFromList(
    Uint8List.fromList(_transparentImage),
  );

  group('AppScope tests |', () {
    testWidgets('creates scope with default cache manager', (tester) async {
      await tester.pumpWidget(
        AppScope(
          child: Builder(
            builder: (context) {
              expect(
                AppScope.cacheManagerOf(context),
                isA<DefaultCacheManager>(),
              );

              return SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('creates scope with provided cache manager', (tester) async {
      await tester.pumpWidget(
        AppScope(
          cacheManager: TestCacheManager(),
          child: Builder(
            builder: (context) {
              expect(AppScope.cacheManagerOf(context), isA<TestCacheManager>());

              return SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets(
      'creates scope for default palette generator',
      (tester) async {
        await tester.pumpWidget(
          AppScope(
            child: Builder(
              builder: (context) {
                AppScope.paletteGeneratorOf(context, image).then((generator) {
                  expect(generator, isA<PaletteGenerator>());
                });

                return SizedBox.shrink();
              },
            ),
          ),
        );
      },
    );

    testWidgets(
      'creates scope for provided palette generator',
      (tester) async {
        await tester.pumpWidget(
          AppScope(
            paletteGenerator: PaletteGenerator.fromColors(
              [
                PaletteColor(Colors.red, 3),
                PaletteColor(Colors.green, 2),
                PaletteColor(Colors.blue, 1),
              ],
            ),
            child: Builder(
              builder: (context) {
                AppScope.paletteGeneratorOf(context, image).then((generator) {
                  expect(generator, isA<PaletteGenerator>());
                });

                return SizedBox.shrink();
              },
            ),
          ),
        );
      },
    );

    testWidgets('update should not notify', (tester) async {
      await tester.pumpWidget(
        AppScope(
          child: Builder(
            builder: (context) {
              expect(
                AppScope.cacheManagerOf(context),
                isA<DefaultCacheManager>(),
              );

              return SizedBox.shrink();
            },
          ),
        ),
      );

      await tester.pumpWidget(
        AppScope(
          child: Builder(
            builder: (context) {
              expect(
                AppScope.cacheManagerOf(context),
                isA<DefaultCacheManager>(),
              );

              return SizedBox.shrink();
            },
          ),
        ),
      );
    });
  });
}

const List<int> _transparentImage = [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x06,
  0x62,
  0x4B,
  0x47,
  0x44,
  0x00,
  0xFF,
  0x00,
  0xFF,
  0x00,
  0xFF,
  0xA0,
  0xBD,
  0xA7,
  0x93,
  0x00,
  0x00,
  0x00,
  0x09,
  0x70,
  0x48,
  0x59,
  0x73,
  0x00,
  0x00,
  0x0B,
  0x13,
  0x00,
  0x00,
  0x0B,
  0x13,
  0x01,
  0x00,
  0x9A,
  0x9C,
  0x18,
  0x00,
  0x00,
  0x00,
  0x07,
  0x74,
  0x49,
  0x4D,
  0x45,
  0x07,
  0xE6,
  0x03,
  0x10,
  0x17,
  0x07,
  0x1D,
  0x2E,
  0x5E,
  0x30,
  0x9B,
  0x00,
  0x00,
  0x00,
  0x0B,
  0x49,
  0x44,
  0x41,
  0x54,
  0x08,
  0xD7,
  0x63,
  0x60,
  0x00,
  0x02,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0xE2,
  0x26,
  0x05,
  0x9B,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
];
