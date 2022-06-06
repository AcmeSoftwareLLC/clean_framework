import '../core/enums/error_code.dart';

export '../core/enums/error_code.dart';
export 'src/flag_not_found_exception.dart';
export 'src/parse_exception.dart';
export 'src/type_mismatch_exception.dart';

abstract class OpenFeatureException {
  OpenFeatureException(this.message, {required this.code});

  final String message;
  final ErrorCode code;
}
