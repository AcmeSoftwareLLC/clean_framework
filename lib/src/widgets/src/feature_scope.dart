import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';

class FeatureScope extends StatefulWidget {
  const FeatureScope({
    super.key,
    required this.child,
  });

  final Widget child;

  static _InheritedFeatureScope of(BuildContext context) {
    final _InheritedFeatureScope? result =
        context.dependOnInheritedWidgetOfExactType<_InheritedFeatureScope>();
    assert(result != null, 'No _InheritedFeatureScope found in context');
    return result!;
  }

  @override
  State<FeatureScope> createState() => _FeatureScopeState();
}

class _FeatureScopeState extends State<FeatureScope> {
  late final FeatureClient _client;

  @override
  void initState() {
    super.initState();
    _client = OpenFeature.instance.getClient();
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

  @override
  bool updateShouldNotify(_InheritedFeatureScope old) => false;
}
