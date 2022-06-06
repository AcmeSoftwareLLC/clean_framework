import 'dart:async';

import 'package:clean_framework/src/defaults/feature_provider/engine/json_evaluation_engine.dart';
import 'package:clean_framework/src/open_feature/open_feature.dart';

import 'engine/open_feature_flags.dart';

class JsonFeatureProvider implements FeatureProvider {
  final JsonEvaluationEngine _engine = JsonEvaluationEngine();
  final Completer<OpenFeatureFlags> _flagsCompleter = Completer();

  @override
  String get name => 'json';

  @override
  Future<ResolutionDetails<bool>> resolveBooleanValue({
    required String flagKey,
    required bool defaultValue,
    required EvaluationContext context,
    required FlagEvaluationOptions options,
  }) async {
    final flags = await _flagsCompleter.future;

    return _engine.evaluate(
      flags: flags,
      flagKey: flagKey,
      returnType: FlagValueType.boolean,
      context: context,
    );
  }

  @override
  Future<ResolutionDetails<num>> resolveNumberValue({
    required String flagKey,
    required num defaultValue,
    required EvaluationContext context,
    required FlagEvaluationOptions options,
  }) async {
    final flags = await _flagsCompleter.future;

    return _engine.evaluate(
      flags: flags,
      flagKey: flagKey,
      returnType: FlagValueType.number,
      context: context,
    );
  }

  @override
  Future<ResolutionDetails<String>> resolveStringValue({
    required String flagKey,
    required String defaultValue,
    required EvaluationContext context,
    required FlagEvaluationOptions options,
  }) async {
    final flags = await _flagsCompleter.future;

    return _engine.evaluate(
      flags: flags,
      flagKey: flagKey,
      returnType: FlagValueType.string,
      context: context,
    );
  }

  @override
  Future<ResolutionDetails<T>> resolveValue<T extends Object>({
    required String flagKey,
    required T defaultValue,
    required EvaluationContext context,
    required FlagEvaluationOptions options,
  }) async {
    final flags = await _flagsCompleter.future;

    return _engine.evaluate(
      flags: flags,
      flagKey: flagKey,
      returnType: FlagValueType.object,
      context: context,
    );
  }

  void feed(OpenFeatureFlags flags) {
    _flagsCompleter.complete(flags);
  }
}
