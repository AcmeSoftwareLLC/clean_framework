// coverage:ignore-file

import '../open_feature_exception.dart';

class ParseException extends OpenFeatureException {
  ParseException(super.message) : super(code: ErrorCode.flagNotFound);
}
