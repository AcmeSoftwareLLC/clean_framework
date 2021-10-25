import 'dart:async';

import 'package:flutter/material.dart';

part 'route_page.dart';
part 'router_scope.dart';

/// A [CFRoutePage] generator.
typedef CFRoutePageGenerator<T> = CFRoutePage<T> Function<T>(
  String routeName, [
  Object? arguments,
]);

/// The router which provides functionality to mutate the navigation stack.
///
/// It is recommended to use [CFRouterScope] which provides an access to
/// the instance of this class to all its descendants.
class CFRouter {
  /// The [Pipe] responsible for notifying the underlying [RouterDelegate] that
  /// the page stack has been updated.
  @protected
  late final Function onUpdate;

  /// The initial route name.
  final String initialRouteName;

  /// The [CFRoutePage] generator.
  final CFRoutePageGenerator routePageGenerator;

  /// Creates a CFRouter.
  CFRouter({
    required this.initialRouteName,
    required this.routePageGenerator,
  }) : _pages = [routePageGenerator(initialRouteName)];

  List<CFRoutePage> _pages;

  /// The list of [CFRoutePage]s currently in the navigation stack.
  List<CFRoutePage> get pages => _pages;

  /// The [CFRoutePage] at the top of the navigation stack .i.e currently visible.
  CFRoutePage get currentPage {
    assert(_pages.isNotEmpty, 'There is no current route.');
    return _pages.last;
  }

  /// The [CFRoutePage] just below the [currentPage] in the navigation stack.
  CFRoutePage? get previousPage {
    // Returns null if there's no previous route.
    final _previousPageIndex = _pages.length - 2;
    if (_previousPageIndex.isNegative) return null;
    return _pages[_previousPageIndex];
  }

  /// Push the route resolved by [routeName] onto the navigation stack,
  /// optionally with an [arguments].
  Future<T> push<T>(String routeName, {Object? arguments}) {
    final routePage = routePageGenerator<T>(routeName, arguments);
    _pages
      ..removeWhere((page) => page.name == routeName)
      ..add(routePage);
    _notifyUpdate();
    return routePage._completer.future;
  }

  /// Replaces the current route with the route resolved by [routeName] onto the navigation stack,
  /// optionally with an [arguments].
  Future<T> replaceWith<T>(String routeName, {Object? arguments}) {
    final routePage = routePageGenerator<T>(routeName, arguments);
    _pages
      ..removeWhere((page) => page.name == routeName)
      ..removeLast()
      ..add(routePage);
    _notifyUpdate();
    return routePage._completer.future;
  }

  /// Pop the top-most route off the navigation stack.
  bool pop<T>([T? value]) {
    if (_pages.length < 2) return false;
    final _lastRoutePage = _pages.last;
    _pages.removeLast();
    _notifyUpdate();
    _lastRoutePage._completer.complete(value);
    return true;
  }

  /// Calls [pop] repeatedly until the route resolved by [routeName]
  /// becomes the top-most route in the navigation stack.
  bool popUntil(String routeName) {
    if (_pages.length < 2) return false;
    if (_pages.every((page) => page.name != routeName)) {
      throw StateError('No route found = $routeName');
    }
    while (_pages.last.name != routeName) {
      _pages.removeLast();
    }
    _notifyUpdate();
    return true;
  }

  /// Updates the navigation stack in granular level with the help of [routeInfoList].
  void update(List<CFRouteInformation> routeInfoList) {
    assert(
        routeInfoList.isNotEmpty, 'There should be at least one initial route');
    _pages = routeInfoList
        .map((r) => routePageGenerator(r.name, r.arguments))
        .toList();
    _notifyUpdate();
  }

  /// Resets the navigation stack to the earliest form
  /// i.e. the [initialRouteName] will be the top-most and only route in the stack.
  bool reset() {
    _pages = [routePageGenerator(initialRouteName)];
    return _notifyUpdate();
  }

  /// Similar to reset, but provides and option to decide a new [initialRoute].
  bool updateInitialRoute(String initialRoute) {
    _pages = [routePageGenerator(initialRoute)];
    return _notifyUpdate();
  }

  bool _notifyUpdate() {
    _pages = List.from(_pages);
    return onUpdate();
  }
}
