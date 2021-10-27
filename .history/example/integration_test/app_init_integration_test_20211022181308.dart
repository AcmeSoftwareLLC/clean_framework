import 'package:clean_framework/clean_framework_tests.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:clean_framework_example/main.dart' as app;

void main() {
  enableLogsInConsole();
  testWidgets('Example app init', (tester) async {
    await startTest(tester, () => app.main());

    await didWidgetAppear('HomePage');
  });
}
