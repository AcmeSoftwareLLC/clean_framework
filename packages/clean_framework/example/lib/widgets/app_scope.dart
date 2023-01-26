import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:palette_generator/palette_generator.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required super.child,
    this.cacheManager,
    this.paletteGenerator,
  });

  final CacheManager? cacheManager;
  final PaletteGenerator? paletteGenerator;

  static CacheManager cacheManagerOf(BuildContext context) {
    return _of(context).cacheManager ?? DefaultCacheManager();
  }

  static Future<PaletteGenerator> paletteGeneratorOf(
    BuildContext context,
    ui.Image image,
  ) async {
    final paletteGenerator = _of(context).paletteGenerator;
    return paletteGenerator ?? await PaletteGenerator.fromImage(image);
  }

  static AppScope _of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(result != null, 'No CacheManagerScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppScope old) => false;
}
