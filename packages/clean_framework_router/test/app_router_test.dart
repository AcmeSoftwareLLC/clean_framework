import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

enum Routes with RoutesMixin {
  home('/'),
  detail('/detail'),
  subDetail('detail'),
  detailWithParam('/detail/:meta'),
  subDetailWithParam('detail/:meta'),
  moreDetail('more-detail'),
  moreDetailRoot('/more-detail');

  const Routes(this.path);

  @override
  final String path;
}

late AppRouter testRouter;

class TestRouter extends AppRouter<Routes> {
  TestRouter({
    required this.routes,
    this.redirect,
    this.observers,
  });

  final List<RouteBase> routes;
  final GoRouterRedirect? redirect;
  final List<NavigatorObserver>? observers;

  @override
  RouterConfiguration configureRouter() {
    return RouterConfiguration(
      routes: routes,
      errorBuilder: (_, _) => const Page404(),
      redirect: redirect,
      observers: observers,
    );
  }
}

void main() {
  group('Router tests | ', () {
    testWidgets(
      'route defined with "/" path is the initial route',
      (tester) async {
        testRouter = TestRouter(
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => const OnTapPage(id: 'Home'),
            ),
            AppRoute(
              route: Routes.detail,
              builder: (_, _) => const OnTapPage(id: 'Detail'),
            ),
          ],
        );
        await pumpApp(tester);

        expect(find.text('Home'), findsOneWidget);
      },
    );

    testWidgets(
      'navigating to sibling route replaces the older sibling',
      (tester) async {
        testRouter = TestRouter(
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.go(Routes.detail),
              ),
            ),
            AppRoute(
              route: Routes.detail,
              builder: (_, _) => const OnTapPage(id: 'Detail'),
            ),
          ],
        );
        await pumpApp(tester);

        // This is to trigger rebuild so that updateShouldNotify is invoked
        // for AppRouterScope.
        await pumpApp(tester);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);

        // to Routes.detail
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);

        final element = tester.element(find.byType(MaterialApp));
        final router = AppRouter.of(element);
        expect(router.location, '/detail');
        expect(element.router.location, '/detail');
      },
    );

    testWidgets(
      'navigating to child route pushes the child on top of the parent',
      (tester) async {
        testRouter = TestRouter(
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.go(Routes.subDetail),
              ),
              routes: [
                AppRoute(
                  route: Routes.subDetail,
                  builder: (_, _) => const OnTapPage(id: 'Detail'),
                ),
              ],
            ),
          ],
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

        testRouter.pop();
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
        expect(testRouter.location, '/');
      },
    );

    testWidgets(
      'navigating with params',
      (tester) async {
        testRouter = TestRouter(
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.go(
                  Routes.detailWithParam,
                  params: {'meta': '123'},
                ),
              ),
            ),
            AppRoute(
              route: Routes.detailWithParam,
              builder: (_, state) => OnTapPage(
                id: 'Detail',
                value: state.params['meta'],
              ),
            ),
          ],
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
      'navigating with params; using to',
      (tester) async {
        testRouter = TestRouter(
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                // ignore: deprecated_member_use_from_same_package
                onTap: (context) => testRouter.to(
                  Routes.detailWithParam,
                  params: {'meta': '123'},
                ),
              ),
            ),
            AppRoute(
              route: Routes.detailWithParam,
              builder: (_, state) => OnTapPage(
                id: 'Detail',
                value: state.params['meta'],
              ),
            ),
          ],
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
        testRouter = TestRouter(
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.go(
                  Routes.detail,
                  queryParams: {'test': '123'},
                ),
              ),
            ),
            AppRoute(
              route: Routes.detail,
              builder: (_, state) => OnTapPage(
                id: 'Detail',
                value: state.queryParams['test'],
              ),
            ),
          ],
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
        testRouter = TestRouter(
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.go(
                  Routes.detail,
                  extra: 123,
                ),
              ),
            ),
            AppRoute(
              route: Routes.detail,
              builder: (_, state) => OnTapPage(
                id: 'Detail',
                value: state.extra.toString(),
              ),
            ),
          ],
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
        testRouter = TestRouter(
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.go(
                  Routes.detailWithParam,
                  params: {'meta': '123'},
                  queryParams: {'b': '456'},
                  extra: 789,
                ),
              ),
            ),
            AppRoute(
              route: Routes.detailWithParam,
              builder: (_, state) => OnTapPage(
                id: 'Detail',
                value:
                    '${state.params['meta']}${state.queryParams['b']}'
                    '${state.extra}',
              ),
            ),
          ],
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
      testRouter = TestRouter(
        routes: [
          AppRoute(
            route: Routes.home,
            builder: (_, _) => OnTapPage(
              id: 'Home',
              onTap: (context) => testRouter.go(Routes.subDetail),
            ),
            routes: [
              AppRoute(
                route: Routes.subDetail,
                builder: (_, state) => OnTapPage(
                  id: 'Detail',
                  onTap: (context) => testRouter.go(Routes.moreDetail),
                ),
                routes: [
                  AppRoute(
                    route: Routes.moreDetail,
                    builder: (_, state) => OnTapPage(
                      id: 'More Detail',
                      onTap: (context) => testRouter.pop(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
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
        testRouter = TestRouter(
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.push(
                  Routes.subDetailWithParam,
                  params: {'meta': '123'},
                  queryParams: {'b': '456'},
                  extra: 789,
                ),
              ),
              routes: [
                AppRoute(
                  route: Routes.subDetailWithParam,
                  builder: (_, state) => OnTapPage(
                    id: 'Detail',
                    value:
                        '${state.params['meta']}${state.queryParams['b']}'
                        '${state.extra}',
                  ),
                ),
              ],
            ),
          ],
        );

        await pumpApp(tester);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);

        testRouter.pop();
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
      },
    );

    testWidgets(
      'navigating using pushReplacement',
      (tester) async {
        testRouter = TestRouter(
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.push(Routes.subDetail),
              ),
              routes: [
                AppRoute(
                  route: Routes.subDetail,
                  builder: (_, state) => OnTapPage(
                    id: 'Detail',
                    onTap: (context) => testRouter.pushReplacement(
                      Routes.moreDetail,
                    ),
                  ),
                  routes: [
                    AppRoute(
                      route: Routes.moreDetail,
                      builder: (_, state) => const OnTapPage(
                        id: 'More Detail',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
        await pumpApp(tester);

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

        testRouter.pop();
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
        expect(find.text('More Detail'), findsNothing);
      },
    );

    testWidgets(
      'navigating using pushReplacementLocation',
      (tester) async {
        testRouter = TestRouter(
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.push(Routes.subDetail),
              ),
              routes: [
                AppRoute(
                  route: Routes.subDetail,
                  builder: (_, state) => OnTapPage(
                    id: 'Detail',
                    onTap: (context) => testRouter.pushReplacementLocation(
                      '/detail/more-detail',
                    ),
                  ),
                  routes: [
                    AppRoute(
                      route: Routes.moreDetail,
                      builder: (_, state) => const OnTapPage(
                        id: 'More Detail',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
        await pumpApp(tester);

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

        testRouter.pop();
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
        expect(find.text('More Detail'), findsNothing);
      },
    );

    testWidgets(
      'navigating using pushLocation',
      (tester) async {
        testRouter = TestRouter(
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.push(Routes.subDetail),
              ),
              routes: [
                AppRoute(
                  route: Routes.subDetail,
                  builder: (_, state) => OnTapPage(
                    id: 'Detail',
                    onTap: (context) => testRouter.pushLocation(
                      '/detail/more-detail',
                    ),
                  ),
                  routes: [
                    AppRoute(
                      route: Routes.moreDetail,
                      builder: (_, state) => const OnTapPage(
                        id: 'More Detail',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
        await pumpApp(tester);

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

        testRouter.pop();
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);
        expect(find.text('More Detail'), findsNothing);

        // ignore: deprecated_member_use_from_same_package
        testRouter.back();
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
        expect(find.text('More Detail'), findsNothing);
      },
    );

    testWidgets(
      'navigating using goLocation',
      (tester) async {
        testRouter = TestRouter(
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.goLocation(
                  '/detail/123?b=456',
                  extra: 789,
                ),
              ),
              routes: [
                AppRoute(
                  route: Routes.subDetailWithParam,
                  builder: (_, state) => OnTapPage(
                    id: 'Detail',
                    value:
                        '${state.params['meta']}${state.queryParams['b']}'
                        '${state.extra}',
                  ),
                ),
              ],
            ),
          ],
        );
        await pumpApp(tester);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);

        expect(testRouter.location, '/detail/123?b=456');

        testRouter.pop();
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
      },
    );

    testWidgets(
      'navigating using open',
      (tester) async {
        testRouter = TestRouter(
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                // ignore: deprecated_member_use_from_same_package
                onTap: (context) => testRouter.open(
                  '/detail/123?b=456',
                  extra: 789,
                ),
              ),
              routes: [
                AppRoute(
                  route: Routes.subDetailWithParam,
                  builder: (_, state) => OnTapPage(
                    id: 'Detail',
                    value:
                        '${state.params['meta']}${state.queryParams['b']}'
                        '${state.extra}',
                  ),
                ),
              ],
            ),
          ],
        );
        await pumpApp(tester);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);

        expect(testRouter.location, '/detail/123?b=456');

        testRouter.pop();
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
      },
    );

    testWidgets('shows error widget when route is not found', (tester) async {
      testRouter = TestRouter(
        routes: [
          AppRoute(
            route: Routes.home,
            builder: (_, _) => OnTapPage(
              id: 'Home',
              onTap: (context) => testRouter.goLocation('/test'),
            ),
          ),
        ],
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
      'calling refresh() will refresh the underlying router',
      (tester) async {
        testRouter = TestRouter(
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.go(Routes.subDetail),
              ),
              routes: [
                AppRoute(
                  route: Routes.subDetail,
                  builder: (_, _) => const OnTapPage(id: 'Detail'),
                ),
              ],
            ),
          ],
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

        testRouter.refresh();
      },
    );

    testWidgets(
      'local redirect',
      (tester) async {
        testRouter = TestRouter(
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.go(Routes.detail),
              ),
            ),
            AppRoute(
              route: Routes.detail,
              builder: (_, _) => const OnTapPage(id: 'Detail'),
              redirect: (context, state) => '/more-detail',
            ),
            AppRoute(
              route: Routes.moreDetailRoot,
              builder: (_, _) => const OnTapPage(id: 'More Detail'),
            ),
          ],
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
        testRouter = TestRouter(
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.go(Routes.detail),
              ),
            ),
            AppRoute(
              route: Routes.detail,
              builder: (_, _) => const OnTapPage(id: 'Detail'),
            ),
            AppRoute(
              route: Routes.moreDetailRoot,
              builder: (_, _) => const OnTapPage(id: 'More Detail'),
            ),
          ],
          redirect: (context, state) {
            if (state.uri.toString() == '/detail') return '/more-detail';
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
        testRouter = TestRouter(
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.go(Routes.detail),
              ),
            ),
            AppRoute(
              route: Routes.detail,
              builder: (_, _) => OnTapPage(
                id: 'Detail',
                onTap: (context) => testRouter.go(Routes.moreDetailRoot),
              ),
            ),
            AppRoute(
              route: Routes.moreDetailRoot,
              builder: (_, _) => const OnTapPage(id: 'More Detail'),
            ),
          ],
        );
        await pumpApp(tester);

        var count = 1;
        final removeListener = testRouter.addListener(
          expectAsync0(
            () {
              switch (count) {
                case 1:
                  expect(testRouter.location, '/detail');
                case 2:
                  expect(testRouter.location, '/more-detail');
              }
              count++;
            },
            count: 2,
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

        testRouter = TestRouter(
          observers: [observer],
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.go(Routes.detail),
              ),
            ),
            AppRoute(
              route: Routes.detail,
              builder: (_, _) => OnTapPage(
                id: 'Detail',
                onTap: (context) => testRouter.go(Routes.moreDetailRoot),
              ),
            ),
            AppRoute(
              route: Routes.moreDetailRoot,
              builder: (_, _) => const OnTapPage(id: 'More Detail'),
            ),
          ],
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
        testRouter = TestRouter(
          routes: [
            AppRoute.page(
              route: Routes.home,
              builder: (_, _) => CupertinoPage(
                child: OnTapPage(
                  id: 'Home',
                  onTap: (context) => testRouter.go(
                    Routes.subDetailWithParam,
                    params: {'meta': '123'},
                    queryParams: {'b': '456'},
                    extra: 789,
                  ),
                ),
              ),
              routes: [
                AppRoute(
                  route: Routes.subDetailWithParam,
                  builder: (_, state) => OnTapPage(
                    id: 'Detail',
                    value:
                        '${state.params['meta']}${state.queryParams['b']}'
                        '${state.extra}',
                  ),
                ),
              ],
            ),
          ],
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

        testRouter.pop();
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
      },
    );

    testWidgets(
      'using custom transition',
      (tester) async {
        testRouter = TestRouter(
          routes: [
            AppRoute.custom(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.go(
                  Routes.subDetailWithParam,
                  params: {'meta': '123'},
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
                  route: Routes.subDetailWithParam,
                  builder: (_, state) => OnTapPage(
                    id: 'Detail',
                    value:
                        '${state.params['meta']}${state.queryParams['b']}'
                        '${state.extra}',
                  ),
                ),
              ],
            ),
          ],
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

        testRouter.pop();
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
      },
    );

    testWidgets(
      'by default custom routes has no transition',
      (tester) async {
        testRouter = TestRouter(
          routes: [
            AppRoute(
              route: Routes.home,
              builder: (_, _) => OnTapPage(
                id: 'Home',
                onTap: (context) => testRouter.go(
                  Routes.subDetailWithParam,
                  params: {'meta': '123'},
                  queryParams: {'b': '456'},
                  extra: 789,
                ),
              ),
              routes: [
                AppRoute.custom(
                  route: Routes.subDetailWithParam,
                  builder: (_, state) => OnTapPage(
                    id: 'Detail',
                    value:
                        '${state.params['meta']}${state.queryParams['b']}'
                        '${state.extra}',
                  ),
                ),
              ],
            ),
          ],
        );
        await pumpApp(tester);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsNothing);
        expect(find.text('Detail'), findsOneWidget);

        expect(testRouter.location, '/detail/123?b=456');

        testRouter.pop();
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Detail'), findsNothing);
      },
    );

    test('location from the route', () {
      testRouter = TestRouter(
        routes: [
          AppRoute(
            route: Routes.home,
            builder: (_, _) => const OnTapPage(id: 'Home'),
          ),
        ],
      );

      expect(testRouter.locationOf(Routes.home), equals('/'));
    });
  });
}

Future<void> pumpApp(WidgetTester tester) {
  return tester.pumpWidget(
    AppRouterScope(
      create: () => testRouter,
      builder: (context) => MaterialApp.router(routerConfig: testRouter.config),
    ),
  );
}

class OnTapPage extends StatelessWidget {
  const OnTapPage({required this.id, super.key, this.onTap, this.value});

  final String id;
  final void Function(BuildContext)? onTap;
  final String? value;

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
            child: const Text('Navigate'),
            onPressed: () => onTap?.call(context),
          ),
        ],
      ),
    );
  }
}

class Page404 extends StatelessWidget {
  const Page404({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('404'),
      ),
    );
  }
}

class TestNavigatorObserver extends NavigatorObserver {
  String? removedRoute;

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    removedRoute = (route.settings as MaterialPage).name;
  }
}
