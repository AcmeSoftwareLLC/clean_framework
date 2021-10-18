import 'package:flutter/widgets.dart';

import 'router.dart';

/// Extension methods to Clean Framework Routing.
extension CFRouterExtension on BuildContext {
  /// The [CFRouter] in the current context.
  ///
  /// Alternatively, [CFRouterScope.of(context)] can used.
  CFRouter get router => CFRouterScope.of(this);

  /// The arguments passed to this route.
  T routeArguments<T>() {
    final args = _routeSettings.arguments as T?;
    assert(
      args != null,
      'You might have forgotten to pass arguments while routing to this page.\n'
      'If this was on purpose and you expect a null argument, then consider using context.routeArgumentsMayBe() instead.',
    );
    return args!;
  }

  /// Similar to [routeArguments], but can return null arguments.
  T? routeArgumentsMayBe<T>() => _routeSettings.arguments as T?;

  RouteSettings get _routeSettings {
    final modalRoute = ModalRoute.of(this);
    if (modalRoute != null) return modalRoute.settings;
    throw Exception('Route is not ready to extract arguments.');
  }
}
