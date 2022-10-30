import 'enums.dart';

class ResolutionDetails<T> {
  ResolutionDetails({
    required this.value,
    this.errorCode,
    this.reason,
    this.variant,
  });

  final T value;
  final ErrorCode? errorCode;
  final Reason? reason;
  final String? variant;
}
