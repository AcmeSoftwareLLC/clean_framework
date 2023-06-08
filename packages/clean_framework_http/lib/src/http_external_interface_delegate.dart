import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_http/clean_framework_http.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';

export 'package:dio_cache_interceptor/dio_cache_interceptor.dart'
    show MemCacheStore;

typedef HttpCacheOptions = CacheOptions;

abstract class HttpExternalInterfaceDelegate extends ExternalInterfaceDelegate {
  /// Builds the base headers for the HTTP request.
  FutureOr<Map<String, String>?> buildHeaders() => null;

  /// Builds the base options for the HTTP request.
  FutureOr<HttpOptions> buildOptions() => const HttpOptions();

  /// Builds the cache options for the HTTP request.
  ///
  /// If null is returned, the cache interceptor will be disabled.
  Future<HttpCacheOptions?> buildCacheOptions() => SynchronousFuture(null);

  /// Builds the base Dio instance for the HTTP request.
  Future<Dio> buildDio(BaseOptions options) async {
    final dio = Dio(options);
    return SynchronousFuture(dio);
  }
}
