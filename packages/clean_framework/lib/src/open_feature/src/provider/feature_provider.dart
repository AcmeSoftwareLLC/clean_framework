import 'package:clean_framework/src/open_feature/src/core/resolution_details.dart';
import 'package:clean_framework/src/open_feature/src/evaluation_context/evaluation_context.dart';
import 'package:clean_framework/src/open_feature/src/flag_evaluation/flag_evaluation_options.dart';

abstract class FeatureProvider {
  String get name;

  Future<ResolutionDetails<bool>> resolveBooleanValue({
    required String flagKey,
    required bool defaultValue,
    required EvaluationContext context,
    required FlagEvaluationOptions options,
  });

  Future<ResolutionDetails<String>> resolveStringValue({
    required String flagKey,
    required String defaultValue,
    required EvaluationContext context,
    required FlagEvaluationOptions options,
  });

  Future<ResolutionDetails<num>> resolveNumberValue({
    required String flagKey,
    required num defaultValue,
    required EvaluationContext context,
    required FlagEvaluationOptions options,
  });

  Future<ResolutionDetails<T>> resolveValue<T extends Object>({
    required String flagKey,
    required T defaultValue,
    required EvaluationContext context,
    required FlagEvaluationOptions options,
  });
}
