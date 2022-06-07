import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';

class FeatureScope<T extends FeatureProvider> extends StatefulWidget {
  const FeatureScope({
    super.key,
    required this.register,
    required this.child,
    this.loader,
    this.onLoaded,
  });

  final T Function() register;
  final Widget child;
  final Future<void> Function(T)? loader;
  final VoidCallback? onLoaded;

  static _InheritedFeatureScope of(BuildContext context) {
    final _InheritedFeatureScope? result =
        context.dependOnInheritedWidgetOfExactType<_InheritedFeatureScope>();
    assert(result != null, 'No _InheritedFeatureScope found in context');
    return result!;
  }

  @override
  State<FeatureScope<T>> createState() => _FeatureScopeState<T>();
}

class _FeatureScopeState<T extends FeatureProvider>
    extends State<FeatureScope<T>> {
  late final FeatureClient _client;

  @override
  void initState() {
    super.initState();
    final featureProvider = widget.register();

    OpenFeature.instance.provider = featureProvider;
    _client = OpenFeature.instance.getClient();

    _load(featureProvider);
  }

  Future<void> _load(T featureProvider) async {
    if (widget.loader != null) {
      await widget.loader!.call(featureProvider);
      widget.onLoaded?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedFeatureScope(
      client: _client,
      child: widget.child,
    );
  }
}

class _InheritedFeatureScope extends InheritedWidget {
  const _InheritedFeatureScope({
    required Widget child,
    required this.client,
  }) : super(child: child);

  final FeatureClient client;

  // coverage:ignore-start
  @override
  bool updateShouldNotify(_InheritedFeatureScope old) => false;
  // coverage:ignore-end
}
