import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_router/src/app_router_base.dart';
import 'package:clean_framework_router/src/app_router_scope.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Wrapper class around [GoRouter].
abstract class AppRouter<R extends Enum> implements AppRouterBase<R> {
  AppRouter() {
    GoRouter.optionURLReflectsImperativeAPIs = optionURLReflectsImperativeAPIs;
    _router = configureRouter()..routerDelegate.addListener(_onLocationChanged);
  }

  late final RouterConfiguration _router;

  /// Whether the imperative API affects browser URL bar.
  ///
  /// The Imperative APIs refer to [push], [pushReplacement].
  ///
  /// If this option is set to true. The URL bar reflects the top-most [GoRoute]
  /// regardless the [RouteBase]s underneath.
  ///
  /// If this option is set to false. The URL bar reflects the [RouteBase]s
  /// in the current state but ignores any [RouteBase]s that are results of
  /// imperative API calls.
  ///
  /// Defaults to false.
  ///
  /// This option is for backward compatibility. It is strongly suggested
  /// against setting this value to true, as the URL of the top-most [GoRoute]
  /// is not always deeplink-able.
  ///
  /// This option only affects web platform.
  bool get optionURLReflectsImperativeAPIs => false;

  @override
  void go(
    R route, {
    RouterParams<String> params = const {},
    RouterParams<dynamic> queryParams = const {},
    Object? extra,
  }) {
    return _router.goNamed(
      route.name,
      pathParameters: params,
      queryParameters: queryParams,
      extra: extra,
    );
  }

  @override
  Future<T?> push<T extends Object>(
    R route, {
    RouterParams<String> params = const {},
    RouterParams<dynamic> queryParams = const {},
    Object? extra,
  }) {
    return _router.pushNamed(
      route.name,
      pathParameters: params,
      queryParameters: queryParams,
      extra: extra,
    );
  }

  @override
  Future<void> pushReplacement(
    R route, {
    RouterParams<String> params = const {},
    RouterParams<dynamic> queryParams = const {},
    Object? extra,
  }) {
    return _router.pushReplacementNamed(
      route.name,
      pathParameters: params,
      queryParameters: queryParams,
      extra: extra,
    );
  }

  @override
  Future<T?> pushLocation<T extends Object>(String location, {Object? extra}) {
    return _router.push(location, extra: extra);
  }

  @override
  void goLocation(String location, {Object? extra}) {
    return _router.go(location, extra: extra);
  }

  @override
  Future<void> pushReplacementLocation(String location, {Object? extra}) {
    return _router.pushReplacement(location, extra: extra);
  }

  @override
  bool canPop() => _router.canPop();

  @override
  void pop<T extends Object?>([T? result]) {
    return _router.pop(result);
  }

  @override
  String locationOf(
    R route, {
    RouterParams<String> params = const {},
    RouterParams<dynamic> queryParams = const {},
  }) {
    return _router.namedLocation(
      route.name,
      pathParameters: params,
      queryParameters: queryParams,
    );
  }

  @override
  VoidCallback addListener(VoidCallback listener) {
    _router.routerDelegate.addListener(listener);
    return () => _router.routerDelegate.removeListener(listener);
  }

  void refresh() => _router.refresh();

  @override
  String get location {
    return _router.routerDelegate.currentConfiguration.uri.toString();
  }

  RouterConfig<Object> get config => _router;

  @Deprecated('Use go instead.')
  void to(
    R route, {
    Map<String, String> params = const {},
    Map<String, String> queryParams = const {},
    Object? extra,
  }) {
    return go(
      route,
      params: params,
      queryParams: queryParams,
      extra: extra,
    );
  }

  @Deprecated('Use goLocation instead.')
  void open(String location, {Object? extra}) {
    goLocation(location, extra: extra);
  }

  @Deprecated('Use pop instead.')
  void back() => _router.pop();

  @override
  void dispose() {
    _router.routerDelegate.removeListener(_onLocationChanged);
  }

  static AppRouter of(BuildContext context) {
    return AppRouterScope.of(context).router;
  }

  void _onLocationChanged() {
    CleanFrameworkObserver.instance.onLocationChanged(location);
  }
}
