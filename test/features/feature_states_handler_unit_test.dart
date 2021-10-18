import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FeatureStatesHandler load and append json', () {
    final states = TestFeatureStateMapper();

    states.load({
      'features': [
        {'name': 'login', 'version': '1.0', 'state': 'VISIBLE'},
      ]
    });

    expect(states.getStateFor(Feature(name: 'login')), FeatureState.visible);

    expect(
        states.getStateFor(Feature(name: 'non-existant')), FeatureState.hidden);

    states.append({
      'features': [
        {'name': 'biometrics', 'version': '1.5', 'state': 'VISIBLE'},
      ]
    });

    expect(states.getStateFor(Feature(name: 'login')), FeatureState.visible);

    expect(states.getStateFor(Feature(name: 'biometrics', version: '1.5')),
        FeatureState.visible);
  });
}

class TestFeatureStateMapper extends FeatureMapper<FeatureState> {
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
