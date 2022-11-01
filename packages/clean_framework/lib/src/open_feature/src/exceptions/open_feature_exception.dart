// coverage:ignore-file

import 'package:clean_framework/src/open_feature/src/core/enums/error_code.dart';

export '../core/enums/error_code.dart';
export 'src/flag_not_found_exception.dart';
export 'src/parse_exception.dart';
export 'src/type_mismatch_exception.dart';

abstract class OpenFeatureException implements Exception {
  OpenFeatureException(this.message, {required this.code});

  final String message;
  final ErrorCode code;
}
