import 'dart:developer';

import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';

typedef FeatureBuilderCallback<T extends Object> = Widget Function(
  BuildContext,
  T,
);

class FeatureBuilder<T extends Object> extends StatefulWidget {
  const FeatureBuilder({
    super.key,
    required this.flagKey,
    required this.defaultValue,
    required this.builder,
    this.evaluationContext,
  });

  final String flagKey;
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
    Future<Object> future;

    final defaultValue = widget.defaultValue;

    if (defaultValue is bool) {
      future = client.getBooleanValue(
        key: widget.flagKey,
        defaultValue: defaultValue,
        context: widget.evaluationContext,
      );
    } else if (defaultValue is String) {
      future = client.getStringValue(
        key: widget.flagKey,
        defaultValue: defaultValue,
        context: widget.evaluationContext,
      );
    } else if (defaultValue is num) {
      future = client.getNumberValue(
        key: widget.flagKey,
        defaultValue: widget.defaultValue as num,
        context: widget.evaluationContext,
      );
    } else {
      future = client.getValue(
        key: widget.flagKey,
        defaultValue: defaultValue,
        context: widget.evaluationContext,
      );
    }

    return await future as T;
  }
}
