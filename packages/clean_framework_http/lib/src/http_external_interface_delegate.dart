import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_http/clean_framework_http.dart';
import 'package:dio/dio.dart';

abstract class HttpExternalInterfaceDelegate extends ExternalInterfaceDelegate {
  /// Builds the base headers for the HTTP request.
  FutureOr<Map<String, String>?> buildHeaders();

  /// Builds the base options for the HTTP request.
  FutureOr<HttpOptions> buildOptions() => const HttpOptions();

  /// Builds the base Dio instance for the HTTP request.
  FutureOr<Dio> buildDio(BaseOptions options) {
    final dio = Dio(options);

    dio.interceptors.add(LogInterceptor());
    return dio;
  }
}
