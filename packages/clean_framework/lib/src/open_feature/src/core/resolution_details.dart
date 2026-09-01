import 'package:clean_framework/src/open_feature/src/core/enums.dart';

class ResolutionDetails<T>({
  required final T value,
  final ErrorCode? errorCode,
  final Reason? reason,
  final String? variant,
});
