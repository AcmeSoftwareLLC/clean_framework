import 'dart:async';

import 'package:meta/meta.dart';

class RestServiceOptions {
  const RestServiceOptions({
    this.baseUrl = '',
    Map<String, String> headers = const {},
  }) : _headers = headers;

  final String baseUrl;
  final Map<String, String> _headers;

  @protected
  FutureOr<Map<String, String>> buildHeaders() {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      ..._headers,
    };
  }

  FutureOr<Map<String, String>> get headers => buildHeaders();
}
