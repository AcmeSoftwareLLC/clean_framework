import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Signature for router's `builder` and `errorBuilder` callback.
typedef RouteWidgetBuilder = Widget Function(BuildContext, GoRouterState);

/// Signature of the page builder callback for a matched AppRoute.
typedef RoutePageBuilder = Page<void> Function(BuildContext, GoRouterState);

class AppRoute extends GoRoute {
  AppRoute({
    required this.route,
    super.builder,
    super.routes,
    super.redirect,
  }) : super(path: route.path, name: (route as Enum).name);

  AppRoute.page({
    required this.route,
    RoutePageBuilder? builder,
    super.routes,
    super.redirect,
  }) : super(
          path: route.path,
          name: (route as Enum).name,
          pageBuilder: builder,
        );

  AppRoute.custom({
    required this.route,
    RouteWidgetBuilder? builder,
    RouteTransitionsBuilder? transitionsBuilder,
    super.routes,
    super.redirect,
  }) : super(
          path: route.path,
          name: (route as Enum).name,
          pageBuilder: builder == null
              ? null
              : (context, state) {
                  final transBuilder =
                      transitionsBuilder ?? (_, __, ___, child) => child;

                  return CustomTransitionPage(
                    child: builder(context, state),
                    transitionsBuilder: transBuilder,
                  );
                },
        );

  final RoutesMixin route;
}

mixin RoutesMixin {
  String get path;
}
