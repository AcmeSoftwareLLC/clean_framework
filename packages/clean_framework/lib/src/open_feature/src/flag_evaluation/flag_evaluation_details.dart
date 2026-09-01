import 'package:clean_framework/src/open_feature/src/core/enums.dart';

class FlagEvaluationDetails<T extends Object>({
  required final String key,
  required final T value,
  final ErrorCode? errorCode,
  final Reason? reason,
  final String? variant,
});
