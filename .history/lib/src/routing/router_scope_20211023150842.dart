part of 'router.dart';

/// The [routeName] to widget generator for [CFRouter].
typedef CFRouteGenerator = Widget Function(String routeName);

/// A widget which is responsible for providing access to
/// [CFRouter] instance to its descendants.
@deprecated
class CFRouterScope extends StatefulWidget {
  /// The initial route name.
  final String initialRoute;

  final WidgetBuilder _builder;
  final CFRouteGenerator _routeGenerator;

  /// Create a CFRouter Scope.
  CFRouterScope({
    Key? key,
    required this.initialRoute,
    required CFRouteGenerator routeGenerator,
    required WidgetBuilder builder,
  })  : _builder = builder,
        _routeGenerator = routeGenerator,
        super(key: key);

  @override
  _CFRouterScopeState createState() => _CFRouterScopeState();

  /// Returns the [CFRouter] found in the [context].
  ///
  /// Alternatively, [context.router] can be used.
  static CFRouter of(BuildContext context) {
    final _routerScope =
        context.dependOnInheritedWidgetOfExactType<_CFRouterConfig>();
    assert(
      _routerScope != null,
      'No CFRouterScope ancestor found.\n'
      'CFRouterScope must be at the root of your widget tree in order to access CFRouter, '
      'either using CFRouterScope.of(context) or context.router',
    );
    return _routerScope!.router;
  }
}

class _CFRouterScopeState extends State<CFRouterScope> {
  late CFRouter _router;

  @override
  void initState() {
    super.initState();
    _router = _createRouter();
  }

  @override
  void didUpdateWidget(CFRouterScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRoute != widget.initialRoute) {
      _router.updateInitialRoute(widget.initialRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _CFRouterConfig(
      initialRoute: widget.initialRoute,
      router: _router,
      child: Builder(builder: widget._builder),
    );
  }

  CFRouter _createRouter() {
    return CFRouter(
      initialRouteName: widget.initialRoute,
      routePageGenerator: <T>(String routeName, [Object? arguments]) {
        return CFRoutePage<T>(
          child: widget._routeGenerator(routeName),
          name: routeName,
          arguments: arguments,
        );
      },
    );
  }
}

@deprecated
class _CFRouterConfig extends InheritedWidget {
  final String initialRoute;
  final CFRouter router;

  _CFRouterConfig({
    Key? key,
    required Widget child,
    required this.initialRoute,
    required this.router,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_CFRouterConfig oldWidget) {
    return oldWidget.initialRoute != initialRoute;
  }
}
