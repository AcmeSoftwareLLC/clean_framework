// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/foundation.dart';

int _lineWidth = 100;

abstract class NetworkLogger {
  NetworkLogger() {
    if (kDebugMode && CleanFrameworkObserver.instance.enableNetworkLogs) {
      initialize();
    }
  }

  void initialize();

  String prettyHeaders(Map<String, String> headers) {
    return headers.entries.map((e) => '${e.key}: ${e.value}').join('\n');
  }

  String prettyMap(Map<String, dynamic> map) {
    return const JsonEncoder.withIndent('  ').convert(map);
  }

  void printInLines(String data) {
    final lines = const LineSplitter().convert(data);
    for (final line in lines) {
      print('║  $line');
    }
    printGap();
  }

  void printCategory(String data) {
    final width = (_lineWidth - data.length - 5) ~/ 2;
    final divider = '┄' * width;
    print('╟$divider $data $divider');
    printGap();
  }

  void printHeader(String data, String value) {
    print('\n');
    print('╔╣ $data ╠═ $value');
    printGap();
  }

  void printFooter() {
    print('╚${'═' * _lineWidth}');
    print('\n');
  }

  void printGap() {
    print('║');
  }
}
