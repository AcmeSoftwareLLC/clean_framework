import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

enum UITestRouteAction {
  push,
  pushLocation,
  pushReplacement,
  pushReplacementLocation,
  go,
}

class UITestRouteData {
  UITestRouteData({
    required this.action,
    required this.extra,
    this.params = const {},
    this.queryParams = const {},
    this.location,
    this.route,
  });

  final UITestRouteAction action;
  final Object? extra;
  final RouterParams params;
  final RouterParams queryParams;
  final String? location;
  final Enum? route;

  @override
  String toString() {
    return 'UITestRouteData{action: $action, '
        'location: $location, route: $route, '
        'extra: $extra, params: $params, queryParams: $queryParams}';
  }
}

class UITestRouter extends AppRouter {
  UITestRouteData? _routeData;
  UITestRouteData? _poppedRouteData;

  @override
  RouterConfiguration configureRouter() {
    return RouterConfiguration(routes: []);
  }

  @override
  void go(
    Enum route, {
    RouterParams params = const {},
    RouterParams queryParams = const {},
    Object? extra,
  }) {
    _routeData = UITestRouteData(
      action: UITestRouteAction.go,
      params: params,
      queryParams: queryParams,
      extra: extra,
      route: route,
    );
  }

  @override
  Future<T?> push<T extends Object>(
    Enum route, {
    RouterParams params = const {},
    RouterParams queryParams = const {},
    Object? extra,
  }) {
    _routeData = UITestRouteData(
      action: UITestRouteAction.push,
      params: params,
      queryParams: queryParams,
      extra: extra,
      route: route,
    );
    return SynchronousFuture(null);
  }

  @override
  Future<T?> pushLocation<T extends Object>(String location, {Object? extra}) {
    _routeData = UITestRouteData(
      action: UITestRouteAction.pushLocation,
      location: location,
      extra: extra,
    );
    return SynchronousFuture(null);
  }

  @override
  Future<void> pushReplacement(
    Enum route, {
    RouterParams params = const {},
    RouterParams queryParams = const {},
    Object? extra,
  }) async {
    _routeData = UITestRouteData(
      action: UITestRouteAction.pushReplacement,
      params: params,
      queryParams: queryParams,
      extra: extra,
      route: route,
    );
  }

  @override
  Future<void> pushReplacementLocation(String location, {Object? extra}) async {
    _routeData = UITestRouteData(
      action: UITestRouteAction.pushReplacementLocation,
      location: location,
      extra: extra,
    );
  }

  @override
  void pop() => _poppedRouteData = _routeData;

  UITestRouteData? get data => _routeData;
  UITestRouteData? get poppedData => _poppedRouteData;
}

@isTest
void uiTest<V extends ViewModel>(
  String description, {
  required UI ui,
  required V viewModel,
  required FutureOr<void> Function(WidgetTester) verify,
  List<Override> overrides = const [],
  Widget Function(BuildContext, Widget)? builder,
}) {
  testWidgets(
    description,
    (tester) async {
      await tester.pumpWidget(
        AppProviderScope(
          overrides: overrides,
          child: AppRouterScope(
            create: UITestRouter.new,
            builder: (context) {
              final child = MaterialApp(
                home: ViewModelScope(
                  viewModel: viewModel,
                  child: ui,
                ),
              );

              return builder?.call(context, child) ?? child;
            },
          ),
        ),
      );

      await verify(tester);
    },
  );
}

extension UIRouterTesterExtension on WidgetTester {
  UITestRouteData? get routeData {
    final router = element(find.byType(MaterialApp)).router as UITestRouter;
    return router.data;
  }

  UITestRouteData? get poppedRouteData {
    final router = element(find.byType(MaterialApp)).router as UITestRouter;
    return router.data;
  }
}
