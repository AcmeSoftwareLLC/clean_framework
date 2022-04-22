import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:gql/language.dart';

int _lineWidth = 100;

class GraphQLLoggerLink extends Link {
  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    _RequestLogger(request: request);

    return forward!(request).map((response) {
      print(response);
      return response;
    });
  }

  static Link withParent(Link parent) {
    return Link.concat(GraphQLLoggerLink(), parent);
  }
}

class _RequestLogger {
  _RequestLogger({required this.request}) {
    _printHeader('REQUEST', 'https://google.com');
    _printQuery();
    _printVariables();
    _printFooter();
  }

  final Request request;

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
