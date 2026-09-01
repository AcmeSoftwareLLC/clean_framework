// coverage:ignore-file

import 'package:clean_framework/src/open_feature/src/core/enums/error_code.dart';

export '../core/enums/error_code.dart';
export 'src/flag_not_found_exception.dart';
export 'src/parse_exception.dart';
export 'src/type_mismatch_exception.dart';

abstract class OpenFeatureException(
  final String message, {
  required final ErrorCode code,
}) implements Exception;
