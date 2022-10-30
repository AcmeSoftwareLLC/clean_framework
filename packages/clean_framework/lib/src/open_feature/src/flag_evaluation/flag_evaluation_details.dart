import 'package:clean_framework/src/open_feature/src/core/enums.dart';

class FlagEvaluationDetails<T extends Object> {
  FlagEvaluationDetails({
    required this.key,
    required this.value,
    this.errorCode,
    this.reason,
    this.variant,
  });

  final String key;
  final T value;
  final ErrorCode? errorCode;
  final Reason? reason;
  final String? variant;
}
