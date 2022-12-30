import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Example app init', (tester) async {
    app.main();

    final Finder finder = find.byKey(Key('HomePage'));
    await tester.pumpAndSettle();
    expect(finder, findsWidgets);
  });
}
