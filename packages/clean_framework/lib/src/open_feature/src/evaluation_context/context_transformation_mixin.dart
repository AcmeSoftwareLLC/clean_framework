import 'dart:async';

import '../provider/feature_provider.dart';
import 'evaluation_context.dart';

mixin ContextTransformationMixin on FeatureProvider {
  FutureOr<EvaluationContext> transformContext(EvaluationContext context);
}
