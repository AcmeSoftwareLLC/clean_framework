import '../open_feature_exception.dart';

class TypeMismatchException extends OpenFeatureException {
  TypeMismatchException(super.message) : super(code: ErrorCode.typeMismatch);
}
