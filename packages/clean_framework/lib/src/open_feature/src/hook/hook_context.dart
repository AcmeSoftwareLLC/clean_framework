// coverage:ignore-file

import 'package:clean_framework/src/open_feature/src/core/enums/flag_value_type.dart';
import 'package:clean_framework/src/open_feature/src/core/feature_client.dart';
import 'package:clean_framework/src/open_feature/src/evaluation_context/evaluation_context.dart';
import 'package:clean_framework/src/open_feature/src/provider/feature_provider.dart';

class HookContext<T extends Object>({
  required final String flagKey,
  required final FlagValueType flagType,
  required final EvaluationContext context,
  required final T defaultValue,
  required final FeatureClient client,
  required final FeatureProvider provider,
}) {
  HookContext<T> apply({required EvaluationContext context}) {
    return HookContext(
      flagKey: flagKey,
      flagType: flagType,
      context: context,
      defaultValue: defaultValue,
      client: client,
      provider: provider,
    );
  }
}
