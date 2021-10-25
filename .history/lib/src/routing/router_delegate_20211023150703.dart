import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'router.dart';

/// A delegate that is used by the [Router] widget to build and configure a
/// navigating widget.
///
/// This delegate is an extension to [RouterDelegate].
class CFRouterDelegate extends RouterDelegate<CFRouteInformation>
    with PopNavigatorRouterDelegateMixin<CFRouteInformation>, ChangeNotifier {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  late CFRouter _router;

  /// The underlying [CFRouter].
  CFRouter get router => _router;

  /// Creates a CFRouterDelegate.
  CFRouterDelegate(
    BuildContext context, {
    GlobalKey<NavigatorState>? navigatorKey,
    void Function(CFRoutePage)? onUpdate,
  }) : navigatorKey = navigatorKey ?? GlobalObjectKey<NavigatorState>(context) {
    _router = CFRouterScope.of(context)
      // ignore: invalid_use_of_protected_member
      ..onUpdate = () {
        onUpdate?.call(_router.currentPage);
        notifyListeners();
        return true;
      };
  }

  @override
  Future<void> setNewRoutePath(CFRouteInformation configuration) {
    if (configuration.name != '/') {
      _router.push(configuration.name, arguments: configuration.arguments);
    }
    return SynchronousFuture(null);
  }

  @override
  CFRouteInformation get currentConfiguration => router.currentPage.information;

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _router.pages,
      onPopPage: (route, result) {
        final success = route.didPop(result);
        if (success) _router.pop();
        return success;
      },
    );
  }
}
