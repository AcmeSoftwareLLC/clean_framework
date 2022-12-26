import 'package:clean_framework_router/src/app_router.dart';
import 'package:flutter/widgets.dart';

class AppRouterScope extends StatefulWidget {
  const AppRouterScope({
    super.key,
    required this.create,
    required this.builder,
  });

  final ValueGetter<AppRouter> create;
  final WidgetBuilder builder;

  // ignore: library_private_types_in_public_api
  static _AppRouterScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_AppRouterScope>();

    assert(
      scope != null,
      'No AppRouterScope found in context. '
      'Please wrap the top level widget with AppRouterScope.',
    );

    return scope!;
  }

  @override
  State<AppRouterScope> createState() => _AppRouterScopeState();
}

class _AppRouterScopeState extends State<AppRouterScope> {
  late final AppRouter _router;

  @override
  void initState() {
    super.initState();
    _router = widget.create();
  }

  @override
  Widget build(BuildContext context) {
    return _AppRouterScope(
      router: _router,
      child: Builder(builder: widget.builder),
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }
}

class _AppRouterScope extends InheritedWidget {
  const _AppRouterScope({
    required this.router,
    required super.child,
  });

  final AppRouter router;

  @override
  bool updateShouldNotify(_AppRouterScope old) => false;
}

extension AppRouterExtension on BuildContext {
  AppRouter get router => AppRouterScope.of(this).router;
}
