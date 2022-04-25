import 'dart:convert';

import 'package:clean_framework/clean_framework.dart';

int _lineWidth = 100;

abstract class NetworkLogger {
  NetworkLogger() {
    if (CleanFrameworkObserver.instance.enableNetworkLogs) {
      initialize();
    }
  }

  void initialize();

  void printInLines(String data) {
    final lines = LineSplitter().convert(data);
    for (final line in lines) {
      print('║  $line');
    }
    _printGap();
  }

  void printCategory(String data) {
    final width = (_lineWidth - data.length - 5) ~/ 2;
    final divider = '${'┄' * width}';
    print('╟$divider $data $divider');
    _printGap();
  }

  void printHeader(String data, String value) {
    print('\n');
    print('╔╣ $data ╠═ $value');
    _printGap();
  }

  void printFooter() {
    print('╚${'═' * _lineWidth}');
    print('\n');
  }

  void _printGap() {
    print('║');
  }
}
