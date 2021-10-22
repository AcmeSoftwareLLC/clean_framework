import 'package:clean_framework_example/home_page.dart';
import 'package:clean_framework_example/routes.dart';
import 'package:flutter_test/flutter_test.dart';

import 'home_page_test.dart';

void main() {
  testWidgets(
    'shows error page when route is not found',
    (tester) async {
      await tester.pumpWidget(buildWidget(HomePage()));

      router.open('/non-existent');
      await tester.pumpAndSettle();

      expect(find.byType(Page404), findsOneWidget);
    },
  );
}
