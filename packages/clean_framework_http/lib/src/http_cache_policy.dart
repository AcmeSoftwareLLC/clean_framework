import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

enum HttpCachePolicy {
  /// Same as [HttpCachePolicy.request] when origin server has no cache config.
  ///
  /// In short, you'll save every successful GET requests.
  forceCache(CachePolicy.forceCache),

  /// Same as [HttpCachePolicy.refresh] when origin server has no cache config.
  refreshForceCache(CachePolicy.refreshForceCache),

  /// Requests and skips cache save even if
  /// response has cache directives.
  noCache(CachePolicy.noCache),

  /// Requests regardless cache availability.
  /// Caches if response has cache directives.
  refresh(CachePolicy.refresh),

  /// Returns the cached value if available (and un-expired).
  ///
  /// Checks against origin server otherwise and updates cache freshness
  /// with returned headers when validation is needed.
  ///
  /// Requests otherwise and caches if response has directives.
  request(CachePolicy.request);

  const HttpCachePolicy(this.value);

  final CachePolicy value;
}
