import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef RouteWidgetBuilder = Widget Function(BuildContext, AppRouteState);

class AppRouter<R extends Object> {
  AppRouter({
    required List<AppRoute> routes,
    required RouteWidgetBuilder errorBuilder,
  }) {
    _router = GoRouter(
      routes: routes.map((r) => r._toGoRoute()).toList(growable: false),
      errorPageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: errorBuilder(context, AppRouteState._fromGoRouteState(state)),
        );
      },
    );
  }

  late final GoRouter _router;

  RouterDelegate<Uri> get delegate => _router.routerDelegate;

  RouteInformationParser<Uri> get informationParser {
    return _router.routeInformationParser;
  }

  void to(
    R route, {
    Map<String, String> params = const {},
    Map<String, String> queryParams = const {},
    Object? extra,
  }) {
    _router.goNamed(
      route.toString().toLowerCase(),
      params: params,
      queryParams: queryParams,
      extra: extra,
    );
  }

  void back() {
    final navigator = _router.navigator;
    assert(
      navigator != null,
      'Ensure that router delegate from app router is passed to MaterialApp or CupertinoApp',
    );
    navigator!.pop();
  }

  String get location => _router.location;
}

class AppRoute<R extends Object> {
  AppRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.routes = const [],
  });

  final R name;
  final String path;
  final RouteWidgetBuilder builder;
  final List<AppRoute> routes;

  GoRoute _toGoRoute() {
    return GoRoute(
      path: path,
      name: name.toString(),
      routes: routes.map((r) => r._toGoRoute()).toList(growable: false),
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: builder(context, AppRouteState._fromGoRouteState(state)),
        );
      },
    );
  }
}

class AppRouteState {
  AppRouteState({
    Map<String, String> params = const {},
    this.queryParams = const {},
    this.extra,
    this.error,
  }) : _params = params;

  final Map<String, String> _params;
  final Map<String, String> queryParams;
  final Object? extra;
  final Exception? error;

  factory AppRouteState._fromGoRouteState(GoRouterState state) {
    return AppRouteState(
      params: state.params,
      queryParams: state.queryParams,
      extra: state.extra,
      error: state.error,
    );
  }

  String getParam(String key) {
    assert(
      _params.containsKey(key),
      'No route param with "$key" key was passed',
    );
    return _params[key]!;
  }
}
