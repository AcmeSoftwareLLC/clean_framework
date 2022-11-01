import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Signature for router's `builder` and `errorBuilder` callback.
typedef RouteWidgetBuilder = Widget Function(BuildContext, AppRouteState);

/// Signature of the page builder callback for a matched AppRoute.
typedef RoutePageBuilder = Page<void> Function(BuildContext, AppRouteState);

/// Signature of the page transitions builder callback for a matched AppRoute.
typedef RouteTransitionsBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
);

/// Signature for router's `redirect` callback.
typedef AppRouterRedirect = String? Function(AppRouteState);

/// Signature of the navigatorBuilder callback.
typedef AppRouterNavigatorBuilder = Widget Function(
  BuildContext context,
  AppRouteState state,
  Widget child,
);

/// The router class providing high level interface for Navigator 2 APIs,
/// backed by [go_router](https://pub.dev/packages/go_router).
///
/// ```dart
/// enum Routes {login, home, feed}
///
/// final router = AppRouter<Routes>(
///   routes: [
///     AppRoute(
///       name: Route.login,
///       path: '/login',
///       builder: (context, state) => LoginPage(),
///     ),
///     AppRoute(
///       name: Route.home,
///       path: '/',
///       builder: (context, state) => HomePage(),
///       routes: [
///         AppRoute(
///           name: Route.feed,
///           path: 'feed',
///           builder: (context, state) => FeedPage(),
///         ),
///       ],
///     ),
///   ],
/// );
/// ```
///
class AppRouter<R extends Object> {
  /// Default constructor to configure a AppRouter with a routes builder,
  /// an error builder and redirections.
  AppRouter({
    required List<AppRoute> routes,
    required RouteWidgetBuilder errorBuilder,
    bool enableLogging = false,
    this.initialLocation = '/',
    AppRouterRedirect? redirect,
    AppRouterNavigatorBuilder? navigatorBuilder,
    this.observers,
  })  : _routes = routes,
        _errorBuilder = errorBuilder,
        _enableLogging = enableLogging,
        _redirect = redirect,
        _navigatorBuilder = navigatorBuilder {
    _initInnerRouter();
  }

  late GoRouter _router;
  final List<AppRoute> _routes;
  final RouteWidgetBuilder _errorBuilder;
  final bool _enableLogging;
  final AppRouterRedirect? _redirect;
  AppRouterNavigatorBuilder? _navigatorBuilder;

  /// NavigatorObserver used to receive change notifications
  /// when navigation changes.
  final List<NavigatorObserver>? observers;

  /// The initial location for the router.
  ///
  /// Default is '/'.
  final String initialLocation;

  /// A delegate that is used by the [Router] widget to build and configure a
  /// navigating widget.
  RouterDelegate<Object> get delegate => _router.routerDelegate;

  /// A delegate that is used by the [Router] widget to parse
  /// a route information into a configuration of type T.
  RouteInformationParser<Object> get informationParser {
    return _router.routeInformationParser;
  }

  /// The route information provider used by the inner router.
  RouteInformationProvider get informationProvider {
    return _router.routeInformationProvider;
  }

  /// The current location of the router.
  String get location => _router.location;

  /// Navigates to specified [route].
  ///
  /// Arguments can be passed to the specified route in three ways:
  ///
  /// 1. Route Parameters
  /// ```dart
  /// path = '/home/:id';
  ///
  /// router.to(Routes.home, params: {'id': '112'}); // location = /home/112
  /// ```
  ///
  /// 2. Query Parameters
  /// ```dart
  /// path = '/home';
  ///
  /// router.to(Routes.home, queryParams: {'id': '112'}); // location = /home?id=112
  /// ```
  ///
  /// 3. Extra(Not recommended when targeting Flutter Web; as the data get lost,
  /// but useful when a complex object is to be passed)
  /// ```dart
  /// path = '/home';
  ///
  /// router.to(Routes.home, extra: 112); // location = /home  |   extra = 112
  /// ```
  ///
  void to(
    R route, {
    Map<String, String> params = const {},
    Map<String, String> queryParams = const {},
    Object? extra,
  }) {
    _router.goNamed(
      route is Enum ? route.name : route.toString(),
      params: params,
      queryParams: queryParams,
      extra: extra,
    );
  }

  /// Navigates to specified [route] by maintaining route stack.
  void push(
    R route, {
    Map<String, String> params = const {},
    Map<String, String> queryParams = const {},
    Object? extra,
  }) {
    _router.pushNamed(
      route is Enum ? route.name : route.toString(),
      params: params,
      queryParams: queryParams,
      extra: extra,
    );
  }

  /// Navigates to specified [location]; similar to how web behaves.
  /// Useful for handling deep links & dynamic links.
  ///
  /// Similar to [to], an [extra] parameter can be passed alongside the route.
  ///
  /// ```dart
  /// path = '/home/:id';
  ///
  /// router.open('/home/123');
  /// ```
  ///
  void open(String location, {Object? extra}) {
    _router.go(location, extra: extra);
  }

  /// Pops the topmost route.
  void back() => _router.navigator!.pop();

  /// Register a closure to be called when the navigation stack changes.
  ///
  /// Adding a listener will provide a function which can be called off
  /// to remove the added listener.
  ///
  /// ```dart
  /// final removeListener = router.addListener(
  ///   (){
  ///     // do something
  ///   },
  /// );
  ///
  /// removeListener(); // removes the listener added above
  /// ```
  void Function() addListener(VoidCallback listener) {
    _router.addListener(listener);
    return () => _router.removeListener(listener);
  }

  /// Overrides the provided navigatorBuilder for tests.
  @visibleForTesting
  // ignore: avoid_setters_without_getters
  set navigatorBuilder(AppRouterNavigatorBuilder? builder) {
    _navigatorBuilder = builder;
  }

  /// Resets the router by creating a new instance of underlying router.
  @visibleForTesting
  void reset() => _initInnerRouter();

  void _initInnerRouter() {
    _router = GoRouter(
      routes: _routes,
      errorPageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: _errorBuilder(context, AppRouteState._fromGoRouteState(state)),
        );
      },
      initialLocation: initialLocation,
      observers: observers,
      navigatorBuilder: (context, state, child) {
        final navigatorChild = _navigatorBuilder?.call(
          context,
          AppRouteState._fromGoRouteState(state),
          child,
        );
        return navigatorChild ?? child;
      },
      debugLogDiagnostics: _enableLogging,
      redirect: _redirect == null
          ? null
          : (state) => _redirect!(AppRouteState._fromGoRouteState(state)),
    )..addListener(_onLocationChanged);
  }

  void _onLocationChanged() {
    CleanFrameworkObserver.instance.onLocationChanged(location);
  }
}

class _AppRoute<R extends Object> extends GoRoute {
  _AppRoute({
    required R name,
    required super.path,
    RouteWidgetBuilder? builder,
    RoutePageBuilder? pageBuilder,
    super.routes,
    super.redirect,
  }) : super(
          name: name is Enum ? name.name : name.toString(),
          builder: (context, state) {
            final child = builder?.call(
              context,
              AppRouteState._fromGoRouteState(state),
            );

            return child ?? const SizedBox.shrink();
          },
          pageBuilder: pageBuilder == null
              ? null
              : (context, state) {
                  return pageBuilder(
                    context,
                    AppRouteState._fromGoRouteState(state),
                  );
                },
        );
}

class AppRoute<R extends Object> extends _AppRoute<R> {
  AppRoute({
    required super.name,
    required super.path,
    required super.builder,
    super.routes,
    super.redirect,
  });

  AppRoute.custom({
    required super.name,
    required super.path,
    required RouteWidgetBuilder builder,
    RouteTransitionsBuilder? transitionsBuilder,
    super.routes,
    super.redirect,
  }) : super(
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: builder(context, state),
              transitionsBuilder:
                  transitionsBuilder ?? (_, __, ___, child) => child,
            );
          },
        );

  AppRoute.page({
    required super.name,
    required super.path,
    required RoutePageBuilder builder,
    super.routes,
    super.redirect,
  }) : super(pageBuilder: builder);
}

/// The state associated with an [AppRoute].
class AppRouteState {
  /// Default constructor to configure an AppRouteState.
  AppRouteState({
    required this.location,
    required this.subloc,
    required this.name,
    this.path,
    this.fullpath,
    Map<String, String> params = const {},
    this.queryParams = const {},
    this.extra,
    this.error,
  }) : _params = params;

  factory AppRouteState._fromGoRouteState(GoRouterState state) {
    return AppRouteState(
      location: state.location,
      subloc: state.subloc,
      name: state.name,
      path: state.path,
      fullpath: state.fullpath,
      params: state.params,
      queryParams: state.queryParams,
      extra: state.extra,
      error: state.error,
    );
  }

  /// The full location of the route
  final String location;

  /// The location of this sub-route, e.g. /family/f2
  final String subloc;

  /// The optional name of the route.
  final String? name;

  /// The specified path for the route as configures in [AppRoute].
  final String? path;

  /// The full path to this sub-route, e.g. /family/:fid
  final String? fullpath;

  /// The query parameters associated with the route.
  final Map<String, String> queryParams;

  /// The extra value associated with the route.
  final Object? extra;

  /// The error thrown by the builder.
  final Exception? error;

  final Map<String, String> _params;

  /// Get the route param for specified [key].
  ///
  /// Throws an assertion error if the route param doesn't contain value
  /// for provided `key`.
  String getParam(String key) {
    assert(
      _params.containsKey(key),
      'No route param with "$key" key was passed',
    );
    return _params[key]!;
  }
}
