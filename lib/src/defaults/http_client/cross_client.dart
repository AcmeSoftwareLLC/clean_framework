import 'package:http/http.dart';

/// Creates a cross platform HttpClient.
///
/// The [trustSelfSigned] property is only used on non-web platform.
///
/// import 'http_client/cross_client.dart'
///     if (dart.library.io) 'package:http/io_client.dart';
Client createHttpClient(bool trustSelfSigned) => Client();
