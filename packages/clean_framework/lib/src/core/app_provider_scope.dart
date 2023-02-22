import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stack_trace/stack_trace.dart';

class AppProviderScope extends StatelessWidget {
  const AppProviderScope({
    required this.child,
    super.key,
    this.externalInterfaceProviders = const [],
    this.overrides = const [],
    this.observers,
    this.parent,
  });

  final Widget child;

  final ProviderContainer? parent;

  /// The listeners that subscribes to changes on providers
  /// stored on this [ProviderScope].
  final List<ProviderObserver>? observers;

  /// Information on how to override a provider/family.
  final List<Override> overrides;

  final List<ExternalInterfaceProvider> externalInterfaceProviders;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      parent: parent,
      observers: observers,
      overrides: overrides,
      child: Builder(
        builder: (context) {
          return _ProviderInitializer(
            container: ProviderScope.containerOf(context),
            externalInterfaceProviders: externalInterfaceProviders,
            child: child,
          );
        },
      ),
    );
  }
}

class _ProviderInitializer extends StatefulWidget {
  const _ProviderInitializer({
    required this.container,
    required this.child,
    required this.externalInterfaceProviders,
  });

  final ProviderContainer container;
  final Widget child;
  final List<ExternalInterfaceProvider> externalInterfaceProviders;

  @override
  State<_ProviderInitializer> createState() => _ProviderInitializerState();
}

class _ProviderInitializerState extends State<_ProviderInitializer> {
  @override
  void initState() {
    super.initState();

    FlutterError.demangleStackTrace = (StackTrace stack) {
      if (stack is Trace) return stack.vmTrace;
      if (stack is Chain) return stack.toTrace().vmTrace;
      return stack;
    };

    for (final provider in widget.externalInterfaceProviders) {
      provider.initializeFor(widget.container);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
