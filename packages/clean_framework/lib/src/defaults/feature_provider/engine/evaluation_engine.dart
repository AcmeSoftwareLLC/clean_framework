import 'package:clean_framework/src/defaults/feature_provider/engine/open_feature_flags.dart';
import 'package:clean_framework/src/open_feature/open_feature.dart';

abstract class EvaluationEngine {
  ResolutionDetails<T> evaluate<T extends Object>({
    required OpenFeatureFlags flags,
    required String flagKey,
    required FlagValueType returnType,
    required EvaluationContext context,
  });
}
