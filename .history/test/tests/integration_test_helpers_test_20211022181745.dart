import 'package:clean_framework/clean_framework_tests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  enableLogsInConsole();
  testWidgets('Example app init', (tester) async {
    await startTest(tester, () => tester.pumpWidget(MaterialApp()));

    await didWidgetAppear('HomePage');
  });
}
