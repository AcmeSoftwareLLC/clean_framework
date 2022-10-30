// coverage:ignore-file

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

      try {
        final response = await _send(request);

        _ResponseLogger(response: response);
        return response;
      } catch (e, s) {
        _ErrorResponseLogger(url: request.url, error: e, stackTrace: s);
        rethrow;
      }
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
    printHeader(
      'REQUEST (${request.method})',
      request.url.replace(queryParameters: {}).toString(),
    );
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
        final payload = Map<String, dynamic>.from(
          jsonDecode(request.body) as Map,
        );

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
  void initialize() {
    printHeader(
      'RESPONSE (${response.statusCode})',
      response.request?.url.replace(queryParameters: {}).toString() ?? '',
    );
    _printBody();
    printFooter();
  }

  void _printBody() {
    final body = response.body;

    try {
      final data = body.isEmpty ? body : jsonDecode(body);
      final dataMap = data is Map<String, dynamic> ? data : {'data': data};

      printCategory('Body');
      printInLines(prettyMap(dataMap));
    } catch (_) {
      printCategory('Raw Body');
      printInLines(body);
    }
  }
}

class _ErrorResponseLogger extends NetworkLogger {
  _ErrorResponseLogger({
    required this.url,
    required this.error,
    required this.stackTrace,
  });

  final Uri url;
  final Object error;
  final StackTrace stackTrace;

  @override
  void initialize() {
    printHeader(
      'RESPONSE (Error)',
      url.replace(queryParameters: {}).toString(),
    );
    _printError();
    printFooter();
  }

  void _printError() {
    printCategory(error.runtimeType.toString());
    printInLines(error.toString());
    printGap();
    printInLines(stackTrace.toString());
  }
}
