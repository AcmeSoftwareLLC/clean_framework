// coverage:ignore-file

import 'package:clean_framework/src/open_feature/src/exceptions/open_feature_exception.dart';

class ParseException extends OpenFeatureException {
  ParseException(super.message) : super(code: ErrorCode.flagNotFound);
}
