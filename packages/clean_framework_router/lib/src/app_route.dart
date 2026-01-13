import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

export 'package:go_router/go_router.dart' show ShellRoute;

/// Signature for router's `builder` and `errorBuilder` callback.
typedef RouteWidgetBuilder = Widget Function(BuildContext, AppRouterState);

/// Signature of the page builder callback for a matched AppRoute.
typedef RoutePageBuilder = Page<void> Function(BuildContext, AppRouterState);

class AppRoute extends GoRoute {
  AppRoute({
    required this.route,
    RouteWidgetBuilder? builder,
    super.onExit,
    super.parentNavigatorKey,
    super.routes,
    super.redirect,
  }) : super(
         path: route.path,
         name: (route as Enum).name,
         builder: builder == null
             ? null
             : (ctx, state) => builder(ctx, AppRouterState.from(state)),
       );

  AppRoute.page({
    required this.route,
    RoutePageBuilder? builder,
    super.onExit,
    super.parentNavigatorKey,
    super.routes,
    super.redirect,
  }) : super(
         path: route.path,
         name: (route as Enum).name,
         pageBuilder: builder == null
             ? null
             : (ctx, state) => builder(ctx, AppRouterState.from(state)),
       );

  AppRoute.custom({
    required this.route,
    RouteWidgetBuilder? builder,
    RouteTransitionsBuilder? transitionsBuilder,
    super.onExit,
    super.parentNavigatorKey,
    super.routes,
    super.redirect,
  }) : super(
         path: route.path,
         name: (route as Enum).name,
         pageBuilder: builder == null
             ? null
             : (context, state) {
                 final transBuilder =
                     transitionsBuilder ?? (_, _, _, child) => child;

                 return CustomTransitionPage(
                   child: builder(context, AppRouterState.from(state)),
                   transitionsBuilder: transBuilder,
                 );
               },
       );

  final RoutesMixin route;
}

class AppRouterState {
  const AppRouterState._({
    required this.pageKey,
    required this.location,
    required this.matchedLocation,
    required this.name,
    required this.path,
    required this.fullPath,
    required this.params,
    required this.queryParams,
    required this.queryParamsAll,
    required this.extra,
    required this.error,
  });

  factory AppRouterState.from(GoRouterState state) {
    final uri = state.uri;

    return AppRouterState._(
      pageKey: state.pageKey,
      location: uri.toString(),
      matchedLocation: state.matchedLocation,
      name: state.name,
      path: state.path,
      fullPath: state.fullPath,
      params: state.pathParameters,
      queryParams: uri.queryParameters,
      queryParamsAll: uri.queryParametersAll,
      extra: state.extra,
      error: state.error,
    );
  }

  final ValueKey<String> pageKey;
  final String location;
  final String matchedLocation;
  final String? name;
  final String? path;
  final String? fullPath;
  final Map<String, String> params;
  final Map<String, String> queryParams;
  final Map<String, List<String>> queryParamsAll;
  final Object? extra;
  final Exception? error;
}

mixin RoutesMixin {
  String get path;
}
