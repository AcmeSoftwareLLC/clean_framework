import 'package:clean_framework/src/clean_framework_observer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Signature for router's `builder` and `errorBuilder` callback.
typedef RouteWidgetBuilder = Widget Function(BuildContext, AppRouteState);

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

  /// NavigatorObserver used to receive change notifications when navigation changes.
  final List<NavigatorObserver>? observers;

  /// The initial location for the router.
  ///
  /// Default is '/'.
  final String initialLocation;

  /// A delegate that is used by the [Router] widget to build and configure a
  /// navigating widget.
  RouterDelegate<Object> get delegate => _router.routerDelegate;

  /// A delegate that is used by the [Router] widget to parse a route information
  /// into a configuration of type T.
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
  /// 3. Extra (Not recommended when targeting Flutter Web; as the data get lost, but useful when a complex object is to be passed)
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
      route.toString().toLowerCase(),
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
  /// Adding a listener will provide a function which can be called off to remove the added listener.
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
  set navigatorBuilder(AppRouterNavigatorBuilder? builder) {
    _navigatorBuilder = builder;
  }

  /// Resets the router by creating a new instance of underlying router.
  @visibleForTesting
  void reset() => _initInnerRouter();

  void _initInnerRouter() {
    _router = GoRouter(
      routes: _routes.map((r) => r._toGoRoute()).toList(growable: false),
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

/// A declarative mapping between a route name, a route path and a builder.
class AppRoute<R extends Object> {
  /// Default constructor to configure an AppRoute.
  AppRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.routes = const [],
    this.redirect,
  });

  /// The name of the route.
  final R name;

  /// The path of the route which shows up in the browser's address bar.
  final String path;

  /// The widget builder which provides the [AppRouteState] for the particular route.
  final RouteWidgetBuilder builder;

  /// The list of children [routes].
  final List<AppRoute> routes;

  /// The redirection callback which can be configured to redirect to certain location
  /// as per the [AppRouteState].
  final AppRouterRedirect? redirect;

  GoRoute _toGoRoute() {
    return GoRoute(
      path: path,
      name: name.toString(),
      routes: routes.map((r) => r._toGoRoute()).toList(growable: false),
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          name: state.name,
          child: builder(context, AppRouteState._fromGoRouteState(state)),
        );
      },
      redirect: (state) => redirect?.call(
        AppRouteState._fromGoRouteState(state),
      ),
    );
  }
}

/// The state associated with an [AppRoute].
class AppRouteState {
  /// Default constructor to configure an AppRouteState.
  AppRouteState({
    required this.location,
    this.path,
    Map<String, String> params = const {},
    this.queryParams = const {},
    this.extra,
    this.error,
  }) : _params = params;

  /// The full location of the route
  final String location;

  /// The specified path for the route as configures in [AppRoute].
  final String? path;

  /// The query parameters associated with the route.
  final Map<String, String> queryParams;

  /// The extra value associated with the route.
  final Object? extra;

  /// The error thrown by the [AppRoute.builder].
  final Exception? error;

  final Map<String, String> _params;

  factory AppRouteState._fromGoRouteState(GoRouterState state) {
    return AppRouteState(
      location: state.location,
      path: state.path,
      params: state.params,
      queryParams: state.queryParams,
      extra: state.extra,
      error: state.error,
    );
  }

  /// Get the route param for specified [key].
  ///
  /// Throws an assertion error if the route param doesn't contain value for provided `key`.
  String getParam(String key) {
    assert(
      _params.containsKey(key),
      'No route param with "$key" key was passed',
    );
    return _params[key]!;
  }
}
