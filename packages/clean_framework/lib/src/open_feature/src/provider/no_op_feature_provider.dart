// coverage:ignore-file

import '../core/enums/reason.dart';
import '../core/resolution_details.dart';
import '../evaluation_context/evaluation_context.dart';
import '../flag_evaluation/flag_evaluation_options.dart';
import 'feature_provider.dart';

class NoOpFeatureProvider implements FeatureProvider {
  const NoOpFeatureProvider();

  @override
  String get name => 'No-op Provider';

  @override
  Future<ResolutionDetails<bool>> resolveBooleanValue({
    required String flagKey,
    required bool defaultValue,
    required EvaluationContext context,
    required FlagEvaluationOptions options,
  }) {
    return _resolve(defaultValue);
  }

  @override
  Future<ResolutionDetails<num>> resolveNumberValue({
    required String flagKey,
    required num defaultValue,
    required EvaluationContext context,
    required FlagEvaluationOptions options,
  }) {
    return _resolve(defaultValue);
  }

  @override
  Future<ResolutionDetails<String>> resolveStringValue({
    required String flagKey,
    required String defaultValue,
    required EvaluationContext context,
    required FlagEvaluationOptions options,
  }) {
    return _resolve(defaultValue);
  }

  @override
  Future<ResolutionDetails<T>> resolveValue<T extends Object>({
    required String flagKey,
    required T defaultValue,
    required EvaluationContext context,
    required FlagEvaluationOptions options,
  }) {
    return _resolve(defaultValue);
  }

  Future<ResolutionDetails<T>> _resolve<T>(T value) async {
    return ResolutionDetails(
      value: value,
      reason: Reason.noop,
    );
  }
}
