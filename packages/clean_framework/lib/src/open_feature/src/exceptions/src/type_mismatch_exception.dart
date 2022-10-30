// coverage:ignore-file

import 'package:clean_framework/src/open_feature/src/exceptions/open_feature_exception.dart';

class TypeMismatchException extends OpenFeatureException {
  TypeMismatchException(super.message) : super(code: ErrorCode.typeMismatch);
}
