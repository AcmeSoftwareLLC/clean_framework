// coverage:ignore-file

import '../open_feature_exception.dart';

class FlagNotFoundException extends OpenFeatureException {
  FlagNotFoundException(super.message) : super(code: ErrorCode.flagNotFound);
}
