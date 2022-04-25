import 'dart:convert';

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
  void initialize() {
    printHeader('REQUEST', request.url.replace(queryParameters: {}).toString());
    _printParams();
    _printPayload();
    _printHeaders();
    printFooter();
  }

  void _printParams() {
    final params = request.url.queryParameters;

    if (params.isNotEmpty) {
      printCategory('Query Parameters');
      printInLines(prettyMap(params));
    }
  }

  void _printPayload() {
    if (request.headers['Content-Type'] ==
        'application/x-www-form-urlencoded') {
      printCategory('Form Fields');
      printInLines(prettyMap(request.bodyFields));
    } else {
      try {
        final payload = jsonDecode(request.body);

        if (payload.isNotEmpty) {
          printCategory('Payload');
          printInLines(prettyMap(payload));
        }
      } catch (_) {
        printCategory('Bytes');
        printInLines(request.bodyBytes.toString());
      }
    }
  }

  void _printHeaders() {
    final headers = request.headers;

    if (headers.isNotEmpty) {
      printCategory('Headers');
      printInLines(prettyHeaders(headers));
    }
  }
}

class _ResponseLogger extends NetworkLogger {
  _ResponseLogger({
    required this.response,
  });

  final Response response;

  @override
  void initialize() {}
}
