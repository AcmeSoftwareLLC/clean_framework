import 'package:clean_framework/clean_framework_tests.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Example app init', (tester) async {
    await startTest(tester, () {});

    expectLater(didWidgetAppear(''), throwsException);
  });
}
