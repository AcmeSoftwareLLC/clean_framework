import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/cupertino.dart';
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

    testWidgets(
      'navigating using push',
      (tester) async {
        testRouter = AppRouter(
          routes: [
            AppRoute(
              name: Routes.home,
              path: '/',
              builder: (_, __) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.push(
                  Routes.detail,
                  params: {'a': '123'},
                  queryParams: {'b': '456'},
                  extra: 789,
                ),
              ),
              routes: [
                AppRoute(
                  name: Routes.detail,
                  path: 'detail/:a',
                  builder: (_, state) => OnTapPage(
                    id: 'Detail',
                    value:
                        '${state.getParam('a')}${state.queryParams['b']}${state.extra}',
                  ),
                ),
              ],
            ),
          ],
          errorBuilder: (_, __) => Page404(),
        );
        await pumpApp(tester);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);

        expect(testRouter.location, '/detail/123?b=456');

        testRouter.back();
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
      },
    );

    testWidgets(
      'navigating using open',
      (tester) async {
        testRouter = AppRouter(
          routes: [
            AppRoute(
              name: Routes.home,
              path: '/',
              builder: (_, __) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.open(
                  '/detail/123?b=456',
                  extra: 789,
                ),
              ),
              routes: [
                AppRoute(
                  name: Routes.detail,
                  path: 'detail/:a',
                  builder: (_, state) => OnTapPage(
                    id: 'Detail',
                    value:
                        '${state.getParam('a')}${state.queryParams['b']}${state.extra}',
                  ),
                ),
              ],
            ),
          ],
          errorBuilder: (_, __) => Page404(),
        );
        await pumpApp(tester);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);

        expect(testRouter.location, '/detail/123?b=456');

        testRouter.back();
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
      },
    );

    testWidgets('shows error widget when route is not found', (tester) async {
      testRouter = AppRouter(
        routes: [
          AppRoute(
            name: Routes.home,
            path: '/',
            builder: (_, __) => OnTapPage(
              id: 'Home',
              onTap: (context) => testRouter.open('/test'),
            ),
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

      expect(find.byType(Page404), findsOneWidget);
    });

    testWidgets(
      'calling reset() will reset the underlying router',
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

        testRouter.reset();
        expect(testRouter.delegate.currentConfiguration, isEmpty);

        // Just resets the underlying router; no change in UI
        // Since this method is only intended for tests
        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);
      },
    );

    testWidgets(
      'throws assertion error if querying key in not found in param',
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
                  params: {'a': 'b'},
                ),
              ),
              routes: [
                AppRoute(
                  name: Routes.detail,
                  path: 'detail/:a',
                  builder: (_, state) => OnTapPage(
                    id: 'Detail',
                    value: state.getParam('c'),
                  ),
                ),
              ],
            ),
          ],
          errorBuilder: (_, state) {
            expect(
              state.error.toString(),
              contains('No route param with "c" key was passed'),
            );
            return Page404();
          },
        );
        await pumpApp(tester);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'local redirect',
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
              redirect: (state) => '/more-detail',
            ),
            AppRoute(
              name: Routes.moreDetail,
              path: '/more-detail',
              builder: (_, __) => OnTapPage(id: 'More Detail'),
            ),
          ],
          errorBuilder: (_, __) => Page404(),
        );
        await pumpApp(tester);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
        expect(find.text('More Detail'), findsNothing);

        // to Routes.detail
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsNothing);
        expect(find.text('More Detail'), findsOneWidget);

        expect(testRouter.location, '/more-detail');
      },
    );

    testWidgets(
      'global redirect',
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
            AppRoute(
              name: Routes.moreDetail,
              path: '/more-detail',
              builder: (_, __) => OnTapPage(id: 'More Detail'),
            ),
          ],
          errorBuilder: (_, __) => Page404(),
          redirect: (state) {
            if (state.location == '/detail') return '/more-detail';
            return null;
          },
        );
        await pumpApp(tester);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
        expect(find.text('More Detail'), findsNothing);

        // to Routes.detail
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsNothing);
        expect(find.text('More Detail'), findsOneWidget);

        expect(testRouter.location, '/more-detail');
      },
    );

    testWidgets(
      'listening to changes in route using addListener',
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
              builder: (_, __) => OnTapPage(
                id: 'Detail',
                onTap: (context) => testRouter.to(Routes.moreDetail),
              ),
            ),
            AppRoute(
              name: Routes.moreDetail,
              path: '/more-detail',
              builder: (_, __) => OnTapPage(id: 'More Detail'),
            ),
          ],
          errorBuilder: (_, __) => Page404(),
        );
        await pumpApp(tester);

        int count = 1;
        final removeListener = testRouter.addListener(
          expectAsync0(
            () {
              // TODO(sarbagya): Update the test when go_router fixes listener being called twice
              switch (count) {
                case 1:
                case 2:
                  expect(testRouter.location, '/detail');
                  break;
                case 3:
                case 4:
                  expect(testRouter.location, '/more-detail');
                  break;
              }
              count++;
            },
            count: 4,
          ),
        );

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
        expect(find.text('More Detail'), findsNothing);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);
        expect(find.text('More Detail'), findsNothing);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsNothing);
        expect(find.text('More Detail'), findsOneWidget);

        removeListener();
      },
    );

    testWidgets(
      'navigation observers',
      (tester) async {
        final observer = TestNavigatorObserver();

        testRouter = AppRouter(
          observers: [observer],
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
              builder: (_, __) => OnTapPage(
                id: 'Detail',
                onTap: (context) => testRouter.to(Routes.moreDetail),
              ),
            ),
            AppRoute(
              name: Routes.moreDetail,
              path: '/more-detail',
              builder: (_, __) => OnTapPage(id: 'More Detail'),
            ),
          ],
          errorBuilder: (_, __) => Page404(),
        );
        await pumpApp(tester);

        expect(observer.removedRoute, isNull);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
        expect(find.text('More Detail'), findsNothing);

        // to Routes.detail
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(observer.removedRoute, Routes.home.name);

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);
        expect(find.text('More Detail'), findsNothing);

        expect(testRouter.location, '/detail');

        // to Routes.moreDetail
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(observer.removedRoute, Routes.detail.name);

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsNothing);
        expect(find.text('More Detail'), findsOneWidget);

        expect(testRouter.location, '/more-detail');
      },
    );

    testWidgets(
      'using page builder',
      (tester) async {
        testRouter = AppRouter(
          routes: [
            AppRoute.page(
              name: Routes.home,
              path: '/',
              builder: (_, __) => CupertinoPage(
                child: OnTapPage(
                  id: 'Home',
                  onTap: (context) => testRouter.push(
                    Routes.detail,
                    params: {'a': '123'},
                    queryParams: {'b': '456'},
                    extra: 789,
                  ),
                ),
              ),
              routes: [
                AppRoute(
                  name: Routes.detail,
                  path: 'detail/:a',
                  builder: (_, state) => OnTapPage(
                    id: 'Detail',
                    value:
                        '${state.getParam('a')}${state.queryParams['b']}${state.extra}',
                  ),
                ),
              ],
            ),
          ],
          errorBuilder: (_, __) => Page404(),
        );
        await pumpApp(tester);

        /// Cupertino page uses Slide transitions for in and out animation.
        expect(find.byType(SlideTransition), findsNWidgets(2));

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);

        expect(testRouter.location, '/detail/123?b=456');

        testRouter.back();
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
      },
    );

    testWidgets(
      'using custom transition',
      (tester) async {
        testRouter = AppRouter(
          routes: [
            AppRoute.custom(
              name: Routes.home,
              path: '/',
              builder: (_, __) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.push(
                  Routes.detail,
                  params: {'a': '123'},
                  queryParams: {'b': '456'},
                  extra: 789,
                ),
              ),
              transitionsBuilder: (context, animation, _, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              routes: [
                AppRoute(
                  name: Routes.detail,
                  path: 'detail/:a',
                  builder: (_, state) => OnTapPage(
                    id: 'Detail',
                    value:
                        '${state.getParam('a')}${state.queryParams['b']}${state.extra}',
                  ),
                ),
              ],
            ),
          ],
          errorBuilder: (_, __) => Page404(),
        );
        await pumpApp(tester);

        expect(find.byType(FadeTransition), findsOneWidget);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);

        expect(testRouter.location, '/detail/123?b=456');

        testRouter.back();
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
      },
    );

    testWidgets(
      'by default custom routes has no transition',
      (tester) async {
        testRouter = AppRouter(
          routes: [
            AppRoute(
              name: Routes.home,
              path: '/',
              builder: (_, __) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.push(
                  Routes.detail,
                  params: {'a': '123'},
                  queryParams: {'b': '456'},
                  extra: 789,
                ),
              ),
              routes: [
                AppRoute.custom(
                  name: Routes.detail,
                  path: 'detail/:a',
                  builder: (_, state) => OnTapPage(
                    id: 'Detail',
                    value:
                        '${state.getParam('a')}${state.queryParams['b']}${state.extra}',
                  ),
                ),
              ],
            ),
          ],
          errorBuilder: (_, __) => Page404(),
        );
        await pumpApp(tester);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);

        expect(testRouter.location, '/detail/123?b=456');

        testRouter.back();
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
      },
    );
  });
}

Future<void> pumpApp(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp.router(
      routerDelegate: testRouter.delegate,
      routeInformationParser: testRouter.informationParser,
      routeInformationProvider: testRouter.informationProvider,
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

class TestNavigatorObserver extends NavigatorObserver {
  String? removedRoute;

  @override
  void didRemove(Route route, Route? previousRoute) {
    removedRoute = (route.settings as MaterialPage).name;
  }
}
