import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Element get navElement => find.byType(Navigator).evaluate().first;

void main() {
  group('Router tests | ', () {
    testWidgets(
      'router can be accessed using CFRouterScope.of(context)',
      (tester) async {
        await tester.pumpWidget(buildWidget(
          generator: (_) => Page404(),
        ));

        expect(CFRouterScope.of(navElement).currentPage.child, isA<Page404>());
      },
    );

    testWidgets(
      'router can be accessed using context.router',
      (tester) async {
        await tester.pumpWidget(buildWidget(
          generator: (_) => Page404(),
        ));

        expect(navElement.router.currentPage.child, isA<Page404>());
      },
    );

    testWidgets(
      'trying to access router when there is no ancestor CFRouterScope, throws assertion',
      (tester) async {
        await tester.pumpWidget(MediaQuery(
          data: const MediaQueryData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Navigator(
              pages: [MaterialPage(child: Page404())],
              onPopPage: (_, __) => true,
            ),
          ),
        ));

        expect(() => CFRouterScope.of(navElement), throwsAssertionError);
        expect(() => navElement.router, throwsAssertionError);
      },
    );

    testWidgets(
      'initialRoute decides the initial page from the navigation stack',
      (tester) async {
        await tester.pumpWidget(buildWidget(
          generator: (name) {
            switch (name) {
              case '/':
                return OnTapPage(id: 'Home');
              case '/detail':
                return OnTapPage(id: 'Detail');
              default:
                return Page404();
            }
          },
        ));

        expect(find.text('Home'), findsOneWidget);
      },
    );

    testWidgets('push', (tester) async {
      await tester.pumpWidget(buildWidget(
        generator: (name) {
          switch (name) {
            case '/':
              return OnTapPage(
                id: 'Home',
                onTap: (context) => context.router.push('/detail'),
              );
            case '/detail':
              return OnTapPage(id: 'Detail');
            default:
              return Page404();
          }
        },
      ));

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Detail'), findsNothing);

      // push
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsNothing);
      expect(find.text('Detail'), findsOneWidget);
    });

    //TODO Fix test
    // testWidgets('push with arguments', (tester) async {
    //   await tester.pumpWidget(buildWidget(
    //     generator: (name) {
    //       switch (name) {
    //         case '/':
    //           return OnTapPage(
    //             id: 'Home',
    //             onTap: (context) => context.router.push(
    //               '/detail',
    //               arguments: {'test': '123'},
    //             ),
    //           );
    //         case '/detail':
    //           return OnTapPage(id: 'Detail');
    //         default:
    //           return Page404();
    //       }
    //     },
    //   ));

    //   expect(find.text('Home'), findsOneWidget);
    //   expect(find.text('Detail'), findsNothing);
    //   final homeContext = find.byType(OnTapPage).evaluate().first;

    //   // push
    //   await tester.tap(find.byType(ElevatedButton));
    //   await tester.pumpAndSettle();

    //   expect(find.text('Home'), findsNothing);
    //   expect(find.text('Detail'), findsOneWidget);
    //   final detailContext = find.byType(OnTapPage).evaluate().first;

    //   expect(homeContext.routeArguments(), {});
    //   expect(detailContext.routeArguments(), {'test': '123'});
    // });

    testWidgets('pop', (tester) async {
      await tester.pumpWidget(buildWidget(
        generator: (name) {
          switch (name) {
            case '/':
              return OnTapPage(
                id: 'Home',
                onTap: (context) => context.router.push('/detail'),
              );
            case '/detail':
              return OnTapPage(
                id: 'Detail',
                onTap: (context) => context.router.pop(),
              );
            default:
              return Page404();
          }
        },
      ));

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Detail'), findsNothing);

      // push
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsNothing);
      expect(find.text('Detail'), findsOneWidget);

      // pop
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Detail'), findsNothing);
    });

    testWidgets('pop can send data back to the source of push', (tester) async {
      await tester.pumpWidget(buildWidget(
        generator: (name) {
          switch (name) {
            case '/':
              return OnTapPage(
                id: 'Home',
                onTap: (context) => context.router.push('/detail').then(
                  expectAsync1((message) {
                    expect(message, 'hello');
                  }),
                ),
              );
            case '/detail':
              return OnTapPage(
                id: 'Detail',
                onTap: (context) => context.router.pop('hello'),
              );
            default:
              return Page404();
          }
        },
      ));

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Detail'), findsNothing);

      // push
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsNothing);
      expect(find.text('Detail'), findsOneWidget);

      // pop
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Detail'), findsNothing);
    });

    testWidgets('currentPage & previousPage', (tester) async {
      await tester.pumpWidget(buildWidget(
        generator: (name) {
          switch (name) {
            case '/':
              return OnTapPage(
                id: 'Home',
                onTap: (context) => context.router.push('/detail'),
              );
            case '/detail':
              return OnTapPage(id: 'Detail');
            default:
              return Page404();
          }
        },
      ));

      expect(navElement.router.previousPage?.name, isNull);
      expect(navElement.router.currentPage.name, '/');

      // push
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(navElement.router.previousPage?.name, '/');
      expect(navElement.router.currentPage.name, '/detail');
    });

    testWidgets('popUntil', (tester) async {
      await tester.pumpWidget(buildWidget(
        generator: (name) {
          switch (name) {
            case '/':
              return OnTapPage(
                id: 'Home',
                onTap: (context) => context.router.push('/detail'),
              );
            case '/detail':
              return OnTapPage(
                id: 'Detail',
                onTap: (context) => context.router.push('/buy'),
              );
            case '/buy':
              return OnTapPage(
                id: 'Buy',
                onTap: (context) => context.router.push('/pay'),
              );
            case '/pay':
              return OnTapPage(
                id: 'Pay',
                onTap: (context) => context.router.popUntil('/detail'),
              );
            default:
              return Page404();
          }
        },
      ));

      expect(navElement.router.previousPage?.name, isNull);
      expect(navElement.router.currentPage.name, '/');

      // push
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(navElement.router.previousPage?.name, '/');
      expect(navElement.router.currentPage.name, '/detail');

      // push
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(navElement.router.previousPage?.name, '/detail');
      expect(navElement.router.currentPage.name, '/buy');

      // push
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(navElement.router.previousPage?.name, '/buy');
      expect(navElement.router.currentPage.name, '/pay');

      // pop until
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(navElement.router.previousPage?.name, '/');
      expect(navElement.router.currentPage.name, '/detail');
    });

    testWidgets('replaceWith', (tester) async {
      await tester.pumpWidget(buildWidget(
        generator: (name) {
          switch (name) {
            case '/':
              return OnTapPage(
                id: 'Home',
                onTap: (context) => context.router.push('/detail'),
              );
            case '/detail':
              return OnTapPage(
                id: 'Detail',
                onTap: (context) => context.router.replaceWith('/buy'),
              );
            case '/buy':
              return OnTapPage(id: 'Buy');
            default:
              return Page404();
          }
        },
      ));

      expect(navElement.router.previousPage?.name, isNull);
      expect(navElement.router.currentPage.name, '/');

      // push
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(navElement.router.previousPage?.name, '/');
      expect(navElement.router.currentPage.name, '/detail');

      // replace with
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(navElement.router.previousPage?.name, '/');
      expect(navElement.router.currentPage.name, '/buy');
    });

    testWidgets('update', (tester) async {
      await tester.pumpWidget(buildWidget(
        generator: (name) {
          switch (name) {
            case '/':
              return OnTapPage(
                id: 'Home',
                onTap: (context) => context.router.update([
                  CFRouteInformation(name: '/pay'),
                  CFRouteInformation(name: '/detail'),
                  CFRouteInformation(name: '/buy'),
                ]),
              );
            case '/detail':
              return OnTapPage(
                id: 'Detail',
                onTap: (context) => context.router.pop(),
              );
            case '/buy':
              return OnTapPage(
                id: 'Buy',
                onTap: (context) => context.router.pop(),
              );
            case '/pay':
              return OnTapPage(
                id: 'Pay',
                onTap: (context) => context.router.pop(),
              );
            default:
              return Page404();
          }
        },
      ));

      expect(find.text('Home'), findsOneWidget);

      // update
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Buy'), findsOneWidget);

      // pop
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Detail'), findsOneWidget);

      // pop
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Pay'), findsOneWidget);
    });

    testWidgets('update', (tester) async {
      await tester.pumpWidget(buildWidget(
        generator: (name) {
          switch (name) {
            case '/':
              return OnTapPage(
                id: 'Home',
                onTap: (context) => context.router.update([
                  CFRouteInformation(name: '/detail'),
                  CFRouteInformation(name: '/buy'),
                  CFRouteInformation(name: '/pay'),
                ]),
              );
            case '/detail':
              return OnTapPage(id: 'Detail');
            case '/buy':
              return OnTapPage(id: 'Buy');
            case '/pay':
              return OnTapPage(
                id: 'Pay',
                onTap: (context) => context.router.reset(),
              );
            default:
              return Page404();
          }
        },
      ));

      expect(find.text('Home'), findsOneWidget);

      // update
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Pay'), findsOneWidget);

      // reset
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('updateInitialRoute', (tester) async {
      await tester.pumpWidget(buildWidget(
        generator: (name) {
          switch (name) {
            case '/':
              return OnTapPage(
                id: 'Splash',
                onTap: (context) => context.router.update([
                  CFRouteInformation(name: '/login'),
                  CFRouteInformation(name: '/dashboard'),
                ]),
              );
            case '/login':
              return OnTapPage(id: 'Login');
            case '/dashboard':
              return OnTapPage(
                id: 'Dashboard',
                onTap: (context) =>
                    context.router.updateInitialRoute('/dashboard'),
              );
            default:
              return Page404();
          }
        },
      ));

      expect(find.text('Splash'), findsOneWidget);

      // update
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsOneWidget);

      // update initial route
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(navElement.router.previousPage?.name, isNull);
      expect(navElement.router.currentPage.name, '/dashboard');
    });

    //TODO Fix test
    // testWidgets('delegate onUpdate', (tester) async {
    //   var count = 1;
    //   await tester.pumpWidget(
    //     buildWidget(
    //       generator: (name) {
    //         switch (name) {
    //           case '/':
    //             return OnTapPage(
    //               id: 'Home',
    //               onTap: (context) => context.router.push('/detail'),
    //             );
    //           case '/detail':
    //             return OnTapPage(
    //               id: 'Detail',
    //               onTap: (context) => context.router.push('/buy'),
    //             );
    //           case '/buy':
    //             return OnTapPage(
    //               id: 'Buy',
    //               onTap: (context) => context.router.push('/pay'),
    //             );
    //           default:
    //             return Page404();
    //         }
    //       },
    //       onUpdate: expectAsync1((page) {
    //         switch (count) {
    //           case 1:
    //             expect(page.name, '/');
    //             break;
    //           case 2:
    //             expect(page.name, '/detail');
    //             break;
    //           case 3:
    //             expect(page.name, '/buy');
    //             break;
    //           case 4:
    //             expect(page.name, '/pay');
    //             break;
    //         }
    //         count++;
    //       }, count: 4),
    //     ),
    //   );

    //   // push
    //   await tester.tap(find.byType(ElevatedButton));
    //   await tester.pumpAndSettle();

    //   // push
    //   await tester.tap(find.byType(ElevatedButton));
    //   await tester.pumpAndSettle();

    //   // push
    //   await tester.tap(find.byType(ElevatedButton));
    //   await tester.pumpAndSettle();
    // });
  });
}

Widget buildWidget({
  String initialRoute = '/',
  required CFRouteGenerator generator,
  void Function(CFRoutePage)? onUpdate,
}) {
  return CFRouterScope(
    initialRoute: initialRoute,
    routeGenerator: generator,
    builder: (context) {
      return MaterialApp.router(
        routerDelegate: CFRouterDelegate(context, onUpdate: onUpdate),
        routeInformationParser: CFRouteInformationParser(),
      );
    },
  );
}

class OnTapPage extends StatelessWidget {
  final String id;
  final void Function(BuildContext)? onTap;

  const OnTapPage({Key? key, required this.id, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(id),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Navigate'),
          onPressed: () => onTap?.call(context),
        ),
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
