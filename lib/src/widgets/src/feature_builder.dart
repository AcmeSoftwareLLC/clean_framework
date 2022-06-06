import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/src/open_feature/open_feature.dart';
import 'package:clean_framework/src/widgets/src/feature_scope.dart';
import 'package:flutter/material.dart';

typedef FeatureBuilderCallback<T extends Object> = Widget Function(
  BuildContext,
  T,
);

class FeatureBuilder<T extends Object> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final client = FeatureScope.of(context).client;

    return FutureBuilder<T>(
      initialData: defaultValue,
      future: _resolver(client),
      builder: (context, snapshot) {
        return builder(context, snapshot.data!);
      },
    );
  }

  Future<T> _resolver(FeatureClient client) async {
    Future<Object> _future;
    switch (valueType) {
      case FlagValueType.boolean:
        _future = client.getBooleanValue(
          key: flagKey,
          defaultValue: defaultValue as bool,
          context: evaluationContext,
        );
        break;
      case FlagValueType.string:
        _future = client.getStringValue(
          key: flagKey,
          defaultValue: defaultValue as String,
          context: evaluationContext,
        );
        break;
      case FlagValueType.number:
        _future = client.getNumberValue(
          key: flagKey,
          defaultValue: defaultValue as num,
          context: evaluationContext,
        );
        break;
      case FlagValueType.object:
        _future = client.getValue(
          key: flagKey,
          defaultValue: defaultValue,
          context: evaluationContext,
        );
        break;
    }

    return (await _future) as T;
  }
}
