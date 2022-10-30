import 'package:clean_framework/src/open_feature/open_feature.dart';

import 'open_feature_flags.dart';

abstract class EvaluationEngine {
  ResolutionDetails<T> evaluate<T extends Object>({
    required OpenFeatureFlags flags,
    required String flagKey,
    required FlagValueType returnType,
    required EvaluationContext context,
  });
}
