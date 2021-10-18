import 'dart:io';

import 'package:http/http.dart';
import 'package:http/io_client.dart';

/// Creates a HttpClient for IO based platforms.
///
/// Enabling the [trustSelfSigned] property will ignore bad certificate errors.
Client createHttpClient(bool trustSelfSigned) {
  final innerClient = HttpClient()
    ..badCertificateCallback = (cert, host, port) => trustSelfSigned;
  return IOClient(innerClient);
}
