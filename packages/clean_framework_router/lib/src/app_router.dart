import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_router/src/app_router_base.dart';
import 'package:clean_framework_router/src/app_router_scope.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

typedef AppRouterState = GoRouterState;

/// Wrapper class around [GoRouter].
abstract class AppRouter<R extends Enum> implements AppRouterBase<R> {
  AppRouter() {
    _router = configureRouter()..addListener(_onLocationChanged);
  }

  late final RouterConfiguration _router;

  @override
  void go(
    R route, {
    RouterParams params = const {},
    RouterParams queryParams = const {},
    Object? extra,
  }) {
    return _router.goNamed(
      route.name,
      params: params,
      queryParams: queryParams,
      extra: extra,
    );
  }

  @override
  void push(
    R route, {
    RouterParams params = const {},
    RouterParams queryParams = const {},
    Object? extra,
  }) {
    return _router.pushNamed(
      route.name,
      params: params,
      queryParams: queryParams,
      extra: extra,
    );
  }

  @override
  void pushReplacement(
    R route, {
    RouterParams params = const {},
    RouterParams queryParams = const {},
    Object? extra,
  }) {
    return _router.pushReplacementNamed(
      route.name,
      params: params,
      queryParams: queryParams,
      extra: extra,
    );
  }

  @override
  void pushLocation(String location, {Object? extra}) {
    return _router.push(location, extra: extra);
  }

  @override
  void goLocation(String location, {Object? extra}) {
    return _router.go(location, extra: extra);
  }

  @override
  void pushReplacementLocation(String location, {Object? extra}) {
    return _router.pushReplacement(location, extra: extra);
  }

  @override
  void pop() => _router.pop();

  @override
  String locationOf(
    R route, {
    RouterParams params = const {},
    RouterParams queryParams = const {},
  }) {
    return _router.namedLocation(
      route.name,
      params: params,
      queryParams: queryParams,
    );
  }

  @override
  VoidCallback addListener(VoidCallback listener) {
    _router.addListener(listener);
    return () => _router.removeListener(listener);
  }

  void refresh() => _router.refresh();

  @override
  String get location => _router.location;

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
    _router.removeListener(_onLocationChanged);
  }

  static AppRouter of(BuildContext context) {
    return AppRouterScope.of(context).router;
  }

  void _onLocationChanged() {
    CleanFrameworkObserver.instance.onLocationChanged(location);
  }
}
