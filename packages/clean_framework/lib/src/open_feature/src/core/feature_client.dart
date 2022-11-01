import 'package:clean_framework/src/open_feature/src/core/features.dart';
import 'package:clean_framework/src/open_feature/src/core/flag_evaluation_lifecycle.dart';

abstract class FeatureClient extends Features
    implements FlagEvaluationLifecycle {}
