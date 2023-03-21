import 'dart:async';

import 'package:clean_framework/clean_framework.dart';

abstract class HttpHeaderDelegate extends ExternalInterfaceDelegate {
  /// Builds the base headers for the HTTP request.
  FutureOr<Map<String, String>> build();
}
