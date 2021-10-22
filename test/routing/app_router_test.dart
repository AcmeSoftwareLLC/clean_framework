import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

enum Routes {
  home,
  detail,
  moreDetail,
}

late AppRouter testRouter;

void main() {
  group('Router tests | ', () {
    testWidgets(
      'route defined with "/" path is the initial route',
      (tester) async {
        testRouter = AppRouter(
          routes: [
            AppRoute(
              name: Routes.home,
              path: '/',
              builder: (_, __) => OnTapPage(id: 'Home'),
            ),
            AppRoute(
              name: Routes.detail,
              path: '/detail',
              builder: (_, __) => OnTapPage(id: 'Detail'),
            ),
          ],
          errorBuilder: (_, __) => Page404(),
        );
        await pumpApp(tester);

        expect(find.text('Home'), findsOneWidget);
      },
    );

    testWidgets(
      'navigating to sibling route replaces the older sibling',
      (tester) async {
        testRouter = AppRouter(
          routes: [
            AppRoute(
              name: Routes.home,
              path: '/',
              builder: (_, __) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.to(Routes.detail),
              ),
            ),
            AppRoute(
              name: Routes.detail,
              path: '/detail',
              builder: (_, __) => OnTapPage(id: 'Detail'),
            ),
          ],
          errorBuilder: (_, __) => Page404(),
        );
        await pumpApp(tester);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);

        // to Routes.detail
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);

        expect(testRouter.location, '/detail');
      },
    );

    testWidgets(
      'navigating to child route pushes the child on top of the parent',
      (tester) async {
        testRouter = AppRouter(
          routes: [
            AppRoute(
              name: Routes.home,
              path: '/',
              builder: (_, __) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.to(Routes.detail),
              ),
              routes: [
                AppRoute(
                  name: Routes.detail,
                  path: 'detail',
                  builder: (_, __) => OnTapPage(id: 'Detail'),
                ),
              ],
            ),
          ],
          errorBuilder: (_, __) => Page404(),
        );
        await pumpApp(tester);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);

        // to Routes.detail
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);

        expect(testRouter.location, '/detail');

        testRouter.back();
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
        expect(testRouter.location, '/');
      },
    );

    testWidgets(
      'navigating with params',
      (tester) async {
        testRouter = AppRouter(
          routes: [
            AppRoute(
              name: Routes.home,
              path: '/',
              builder: (_, __) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.to(
                  Routes.detail,
                  params: {'test': '123'},
                ),
              ),
            ),
            AppRoute(
              name: Routes.detail,
              path: '/detail/:test',
              builder: (_, state) => OnTapPage(
                id: 'Detail',
                value: state.getParam('test'),
              ),
            ),
          ],
          errorBuilder: (_, __) => Page404(),
        );
        await pumpApp(tester);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);

        // to Routes.detail
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);
        expect(find.text('Value: 123'), findsOneWidget);

        expect(testRouter.location, '/detail/123');
      },
    );

    testWidgets(
      'navigating with query parameters',
      (tester) async {
        testRouter = AppRouter(
          routes: [
            AppRoute(
              name: Routes.home,
              path: '/',
              builder: (_, __) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.to(
                  Routes.detail,
                  queryParams: {'test': '123'},
                ),
              ),
            ),
            AppRoute(
              name: Routes.detail,
              path: '/detail',
              builder: (_, state) => OnTapPage(
                id: 'Detail',
                value: state.queryParams['test'],
              ),
            ),
          ],
          errorBuilder: (_, __) => Page404(),
        );
        await pumpApp(tester);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);

        // to Routes.detail
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);
        expect(find.text('Value: 123'), findsOneWidget);

        expect(testRouter.location, '/detail?test=123');
      },
    );

    testWidgets(
      'navigating with extra argument',
      (tester) async {
        testRouter = AppRouter(
          routes: [
            AppRoute(
              name: Routes.home,
              path: '/',
              builder: (_, __) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.to(
                  Routes.detail,
                  extra: 123,
                ),
              ),
            ),
            AppRoute(
              name: Routes.detail,
              path: '/detail',
              builder: (_, state) => OnTapPage(
                id: 'Detail',
                value: state.extra.toString(),
              ),
            ),
          ],
          errorBuilder: (_, __) => Page404(),
        );
        await pumpApp(tester);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);

        // to Routes.detail
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);
        expect(find.text('Value: 123'), findsOneWidget);

        // The route location doesn't hold any information sent using extra.
        expect(testRouter.location, '/detail');
      },
    );

    testWidgets(
      'navigating with every possible type of arguments',
      (tester) async {
        testRouter = AppRouter(
          routes: [
            AppRoute(
              name: Routes.home,
              path: '/',
              builder: (_, __) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.to(
                  Routes.detail,
                  params: {'a': '123'},
                  queryParams: {'b': '456'},
                  extra: 789,
                ),
              ),
            ),
            AppRoute(
              name: Routes.detail,
              path: '/detail/:a',
              builder: (_, state) => OnTapPage(
                id: 'Detail',
                value:
                    '${state.getParam('a')}${state.queryParams['b']}${state.extra}',
              ),
            ),
          ],
          errorBuilder: (_, __) => Page404(),
        );
        await pumpApp(tester);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);

        // to Routes.detail
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);
        expect(find.text('Value: 123456789'), findsOneWidget);

        // The route location doesn't hold any information sent using extra.
        expect(testRouter.location, '/detail/123?b=456');
      },
    );

    testWidgets('pop', (tester) async {
      testRouter = AppRouter(
        routes: [
          AppRoute(
            name: Routes.home,
            path: '/',
            builder: (_, __) => OnTapPage(
              id: 'Home',
              onTap: (context) => testRouter.to(Routes.detail),
            ),
            routes: [
              AppRoute(
                name: Routes.detail,
                path: 'detail',
                builder: (_, state) => OnTapPage(
                  id: 'Detail',
                  onTap: (context) => testRouter.to(Routes.moreDetail),
                ),
                routes: [
                  AppRoute(
                    name: Routes.moreDetail,
                    path: 'more-detail',
                    builder: (_, state) => OnTapPage(
                      id: 'More Detail',
                      onTap: (context) => testRouter.back(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
        errorBuilder: (_, __) => Page404(),
      );
      await pumpApp(tester);

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Detail'), findsNothing);
      expect(find.text('More Detail'), findsNothing);

      expect(testRouter.location, '/');

      // push
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsNothing);
      expect(find.text('Detail'), findsOneWidget);
      expect(find.text('More Detail'), findsNothing);

      expect(testRouter.location, '/detail');

      // push
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsNothing);
      expect(find.text('Detail'), findsNothing);
      expect(find.text('More Detail'), findsOneWidget);

      expect(testRouter.location, '/detail/more-detail');

      // pop
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsNothing);
      expect(find.text('Detail'), findsOneWidget);
      expect(find.text('More Detail'), findsNothing);

      expect(testRouter.location, '/detail');
    });
  });
}

Future<void> pumpApp(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp.router(
      routerDelegate: testRouter.delegate,
      routeInformationParser: testRouter.informationParser,
    ),
  );
}

class OnTapPage extends StatelessWidget {
  final String id;
  final void Function(BuildContext)? onTap;
  final String? value;

  const OnTapPage({Key? key, required this.id, this.onTap, this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(id),
      ),
      body: Column(
        children: [
          Text('Value: $value'),
          ElevatedButton(
            child: Text('Navigate'),
            onPressed: () => onTap?.call(context),
          ),
        ],
      ),
    );
  }
}

class Page404 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('404'),
      ),
    );
  }
}
