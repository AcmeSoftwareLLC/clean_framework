// coverage:ignore-file

import 'package:clean_framework/src/defaults/providers/network_logger.dart';
import 'package:graphql/client.dart';
import 'package:gql/language.dart';

class GraphQLLoggerLink extends Link {
  GraphQLLoggerLink({
    required this.endpoint,
    required this.getHeaders,
  });

  final String endpoint;
  final Future<Map<String, String>> Function() getHeaders;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    _logRequest(request);

    return forward!(request).map(_responseMapper).handleError(_onError);
  }

  Response _responseMapper(Response response) {
    _ResponseLogger(endpoint: endpoint, response: response);

    return response;
  }

  Future<void> _logRequest(Request request) async {
    final headers = await getHeaders();
    _RequestLogger(endpoint: endpoint, request: request, headers: headers);
  }

  void _onError(Object error) {
    if (error is ServerException && error.parsedResponse != null) {
      _ResponseLogger(endpoint: endpoint, response: error.parsedResponse!);
    }
  }
}

class _RequestLogger extends NetworkLogger {
  _RequestLogger({
    required this.endpoint,
    required this.request,
    required this.headers,
  });

  final String endpoint;
  final Request request;
  final Map<String, String> headers;

  @override
  void initialize() {
    printHeader('REQUEST', endpoint);
    _printQuery();
    _printVariables();
    _printHeaders();
    printFooter();
  }

  void _printHeaders() {
    if (headers.isNotEmpty) {
      printCategory('Headers');
      printInLines(prettyHeaders(headers));
    }
  }

  void _printQuery() {
    final document = request.operation.document;
    final rawDocument = printNode(document).replaceAll(
      RegExp(r'\n *__typename'),
      '',
    );

    if (document.definitions.isEmpty) {
      printCategory('Connection Timeout');
    } else {
      printCategory(request.isQuery ? 'Query' : 'Mutation');
      printInLines(rawDocument);
    }
  }

  void _printVariables() {
    final variables = request.variables;

    if (variables.isNotEmpty) {
      printCategory('Variables');
      printInLines(prettyMap(variables));
    }
  }
}

class _ResponseLogger extends NetworkLogger {
  _ResponseLogger({
    required this.endpoint,
    required this.response,
  });

  final String endpoint;
  final Response response;

  @override
  void initialize() {
    printHeader('RESPONSE', endpoint);

    _printData();

    final errors = response.errors ?? [];
    if (errors.isNotEmpty) _printErrors();

    printFooter();
  }

  void _printData() {
    final data = response.data;

    if (data != null) {
      printCategory('Data');
      printInLines(prettyMap(data));
    }
  }

  void _printErrors() {
    final errors = response.errors!;
    for (var i = 1; i <= errors.length; i++) {
      printCategory('Error $i');

      final error = errors[i - 1];
      final extensions = error.extensions ?? {};

      printInLines(error.message);
      printInLines(prettyMap(extensions));
    }
  }
}
