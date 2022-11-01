// coverage:ignore-file

import 'package:clean_framework/src/defaults/feature_provider/engine/evaluation_engine.dart';
import 'package:clean_framework/src/defaults/feature_provider/engine/open_feature_flags.dart';
import 'package:clean_framework/src/open_feature/open_feature.dart';

class JsonEvaluationEngine implements EvaluationEngine {
  const JsonEvaluationEngine();

  @override
  ResolutionDetails<T> evaluate<T extends Object>({
    required OpenFeatureFlags flags,
    required String flagKey,
    required FlagValueType returnType,
    required EvaluationContext context,
  }) {
    final flag = flags[flagKey];

    if (flag == null || flag.state != FlagState.enabled) {
      throw FlagNotFoundException('$flagKey not found.');
    } else if (flag.returnType != returnType) {
      throw TypeMismatchException(
        'Flag value $flagKey had unexpected type ${flag.returnType?.name}, '
        'expected $returnType',
      );
    }

    try {
      final matchedRule = flag.rules.firstWhere(
        (rule) {
          for (final condition in rule.conditions) {
            final value = context[condition.context];
            final conditionValue = condition.value;

            if (condition.op == 'equals') {
              return value == conditionValue;
            }

            if (value is String && conditionValue is String) {
              if (condition.op == 'starts_with') {
                return value.startsWith(conditionValue);
              } else if (condition.op == 'ends_with') {
                return value.endsWith(conditionValue);
              }
            }

            if (value is String && conditionValue is Iterable<String>) {
              if (condition.op == 'ends_with') {
                for (final checkValue in conditionValue) {
                  if (value.contains(checkValue)) return true;
                }
                return false;
              }
            }
          }

          return false;
        },
      );

      final variant = matchedRule.action.variant;

      return ResolutionDetails(
        value: flag.variants[variant] as T,
        variant: variant,
        reason: Reason.targetingMatch,
      );

      // ignore: avoid_catching_errors
    } on StateError {
      return ResolutionDetails(
        value: flag.variants[flag.defaultVariant] as T,
        variant: flag.defaultVariant,
        reason: Reason.noop,
      );
    }
  }
}
