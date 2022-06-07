import 'dart:developer';

import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';

typedef FeatureBuilderCallback<T extends Object> = Widget Function(
  BuildContext,
  T,
);

class FeatureBuilder<T extends Object> extends StatefulWidget {
  FeatureBuilder({
    super.key,
    required this.flagKey,
    required this.valueType,
    required this.defaultValue,
    required this.builder,
    this.evaluationContext,
  });

  final String flagKey;
  final FlagValueType valueType;
  final T defaultValue;
  final FeatureBuilderCallback<T> builder;
  final EvaluationContext? evaluationContext;

  @override
  State<FeatureBuilder<T>> createState() => _FeatureBuilderState<T>();
}

class _FeatureBuilderState<T extends Object> extends State<FeatureBuilder<T>> {
  @override
  Widget build(BuildContext context) {
    final client = FeatureScope.of(context).client;

    return FutureBuilder<T>(
      initialData: widget.defaultValue,
      future: _resolver(client),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log(
            'Resolution Error',
            name: 'Feature Flag',
            error: snapshot.error,
            stackTrace: snapshot.stackTrace,
          );

          return widget.builder(context, widget.defaultValue);
        }

        return widget.builder(context, snapshot.data!);
      },
    );
  }

  Future<T> _resolver(FeatureClient client) async {
    Future<Object> _future;
    switch (widget.valueType) {
      case FlagValueType.boolean:
        _future = client.getBooleanValue(
          key: widget.flagKey,
          defaultValue: widget.defaultValue as bool,
          context: widget.evaluationContext,
        );
        break;
      case FlagValueType.string:
        _future = client.getStringValue(
          key: widget.flagKey,
          defaultValue: widget.defaultValue as String,
          context: widget.evaluationContext,
        );
        break;
      case FlagValueType.number:
        _future = client.getNumberValue(
          key: widget.flagKey,
          defaultValue: widget.defaultValue as num,
          context: widget.evaluationContext,
        );
        break;
      case FlagValueType.object:
        _future = client.getValue(
          key: widget.flagKey,
          defaultValue: widget.defaultValue,
          context: widget.evaluationContext,
        );
        break;
    }

    return (await _future) as T;
  }
}
