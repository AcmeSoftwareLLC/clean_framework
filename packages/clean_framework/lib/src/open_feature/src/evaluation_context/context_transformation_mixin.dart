import 'dart:async';

import 'package:clean_framework/src/open_feature/src/evaluation_context/evaluation_context.dart';
import 'package:clean_framework/src/open_feature/src/provider/feature_provider.dart';

mixin ContextTransformationMixin on FeatureProvider {
  FutureOr<EvaluationContext> transformContext(EvaluationContext context);
}
