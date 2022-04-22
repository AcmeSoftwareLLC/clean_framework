import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:gql/language.dart';

int _lineWidth = 100;

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

    return forward!(request).map((response) {
      print(response);
      return response;
    });
  }

  Future<void> _logRequest(Request request) async {
    final headers = await getHeaders();
    _RequestLogger(endpoint: endpoint, request: request, headers: headers);
  }
}

class _RequestLogger {
  _RequestLogger({
    required this.endpoint,
    required this.request,
    required this.headers,
  }) {
    _printHeader('REQUEST', endpoint);
    _printQuery();
    _printVariables();
    _printHeaders();
    _printFooter();
  }

  final String endpoint;
  final Request request;
  final Map<String, String> headers;

  void _printHeaders() {
    if (headers.isNotEmpty) {
      final rawHeaders = headers.entries.map((e) => '${e.key}: ${e.value}');

      _printCategory('Headers');
      _print(rawHeaders.join('\n'));
    }
  }

  void _printQuery() {
    final document = request.operation.document;
    final rawDocument = printNode(document).replaceAll(
      RegExp(r'\n *__typename'),
      '',
    );

    _printCategory(request.isQuery ? 'Query' : 'Mutation');
    _print(rawDocument);
  }

  void _printVariables() {
    final variables = request.variables;
    final rawVariables = JsonEncoder.withIndent('  ').convert(variables);

    _printCategory('Variables');
    _print(rawVariables);
  }
}

void _print(String data) {
  final lines = LineSplitter().convert(data);
  for (final line in lines) {
    print('║  $line');
  }
  _printGap();
}

void _printCategory(String data) {
  final width = (_lineWidth - data.length - 5) ~/ 2;
  final divider = '${'┄' * width}';
  print('╟$divider $data $divider');
  _printGap();
}

void _printHeader(String data, String value) {
  print('\n');
  print('╔╣ $data ╾ $value');
  _printGap();
}

void _printFooter() {
  print('╚${'═' * _lineWidth}');
  print('\n');
}

void _printGap() {
  print('║');
}
