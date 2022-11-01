import 'dart:async';

import 'package:clean_framework/src/defaults/feature_provider/engine/evaluation_engine.dart';
import 'package:clean_framework/src/defaults/feature_provider/engine/json_evaluation_engine.dart';
import 'package:clean_framework/src/defaults/feature_provider/engine/open_feature_flags.dart';
import 'package:clean_framework/src/open_feature/open_feature.dart';

export 'engine/evaluation_engine.dart';
export 'engine/open_feature_flags.dart';

/// The feature provider with evaluates the provided JSON.
class JsonFeatureProvider implements FeatureProvider {
  /// Default constructor.
  JsonFeatureProvider({
    EvaluationEngine engine = const JsonEvaluationEngine(),
  }) : _engine = engine;

  final EvaluationEngine _engine;
  final Completer<OpenFeatureFlags> _flagsCompleter = Completer();

  // coverage:ignore-start
  @override
  String get name => 'json';
  // coverage:ignore-end

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

  /// Sets the raw flags to be used by the provider.
  void feed(Map<String, dynamic> rawFlags) {
    final flags = Map<String, dynamic>.of(rawFlags);

    for (final flag in flags.entries) {
      final flagObject = Map<String, dynamic>.from(flag.value as Map);

      if (!flagObject.containsKey('returnType')) {
        flagObject['returnType'] = 'boolean';
      }

      if (!flagObject.containsKey('variants')) {
        flagObject['variants'] = {'enabled': true, 'disabled': false};
      }

      if (!flagObject.containsKey('defaultVariant')) {
        flagObject['defaultVariant'] = 'enabled';
      }

      if (!flagObject.containsKey('state')) {
        flagObject['state'] = 'enabled';
      }

      if (!flagObject.containsKey('rules')) {
        flagObject['rules'] = <Map<String, dynamic>>[];
      }

      flags[flag.key] = flagObject;
    }

    _flagsCompleter.complete(OpenFeatureFlags.fromMap(flags));
  }
}
