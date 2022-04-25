import 'package:clean_framework/src/defaults/providers/network_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class RestLoggerClient {
  RestLoggerClient(this.client);

  final Client client;

  Future<Response> send(Request request) async {
    if (kDebugMode) {
      _RequestLogger(request: request);

      final response = await _send(request);

      _ResponseLogger(response: response);
      return response;
    }

    return _send(request);
  }

  void close() => client.close();

  Future<Response> _send(Request request) async {
    return Response.fromStream(await client.send(request));
  }
}

class _RequestLogger extends NetworkLogger {
  _RequestLogger({
    required this.request,
  });

  final Request request;

  @override
  void initialize() {}
}

class _ResponseLogger extends NetworkLogger {
  _ResponseLogger({
    required this.response,
  });

  final Response response;

  @override
  void initialize() {}
}
