import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheManagerScope extends InheritedWidget {
  const CacheManagerScope({
    super.key,
    required super.child,
    this.cacheManager,
  });

  final CacheManager? cacheManager;

  static CacheManager of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<CacheManagerScope>();
    assert(result != null, 'No CacheManagerScope found in context');
    return result!.cacheManager ?? DefaultCacheManager();
  }

  @override
  bool updateShouldNotify(CacheManagerScope old) => false;
}
