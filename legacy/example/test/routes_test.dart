import 'package:example/demo_router.dart';
import 'package:example/home_page.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:flutter_test/flutter_test.dart';

import 'home_page_test.dart';

void main() {
  testWidgets(
    'shows error page when route is not found',
    (tester) async {
      await tester.pumpWidget(buildWidget(HomePage()));

      final router =
          AppRouterScope.of(tester.element(find.byType(HomePage))).router;

      router.goLocation('/non-existent');
      await tester.pumpAndSettle();

      expect(find.byType(Page404), findsOneWidget);
    },
  );
}
