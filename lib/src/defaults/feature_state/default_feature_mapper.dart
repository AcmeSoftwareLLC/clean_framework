import 'package:clean_framework/clean_framework.dart';

import 'feature_state.dart';

/// If the default [FeatureState] enum is enough for your current app,
/// then this default mapper can be imported and used with the
/// instance of the FeatureStateProvider.
class DefaultFeatureMapper extends FeatureMapper<FeatureState> {
  static const Map<String, FeatureState> _jsonStateToFeatureStateMap = {
    'HIDDEN': FeatureState.hidden,
    'VISIBLE': FeatureState.visible,
  };

  @override
  FeatureState parseState(String state) {
    return _jsonStateToFeatureStateMap[state] ?? defaultState;
  }

  @override
  get defaultState => FeatureState.hidden;
}
