import 'flag_evaluation_lifecycle.dart';
import 'features.dart';

abstract class FeatureClient extends Features
    implements FlagEvaluationLifecycle {}
