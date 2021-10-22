import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';

typedef RouteWidgetBuilder = Widget Function(BuildContext, AppRouteState);

class AppRouter<R extends Object> {
  AppRouter({
    required List<AppRoute> routes,
    required RouteWidgetBuilder errorBuilder,
  })  : _routes = routes,
        _errorBuilder = errorBuilder {
    _initInnerRouter();
  }

  late GoRouter _router;
  final List<AppRoute> _routes;
  final RouteWidgetBuilder _errorBuilder;

  RouterDelegate<Uri> get delegate => _router.routerDelegate;

  RouteInformationParser<Uri> get informationParser {
    return _router.routeInformationParser;
  }

  String get location => _router.location;

  void _initInnerRouter() {
    _router = GoRouter(
      routes: _routes.map((r) => r._toGoRoute()).toList(growable: false),
      errorPageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: _errorBuilder(context, AppRouteState._fromGoRouteState(state)),
        );
      },
    );
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

  void open(String location, {Object? extra}) {
    _router.go(location, extra: extra);
  }

  void back() {
    final navigator = _router.navigator;
    assert(
      navigator != null,
      'Ensure that router delegate from app router is passed to MaterialApp or CupertinoApp',
    );
    navigator!.pop();
  }

  @visibleForTesting
  void reset() => _initInnerRouter();
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
