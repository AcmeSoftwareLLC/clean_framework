import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'feature.dart';

/// This class is a requirement to be able to use a FeatureStateProvider. It
/// specifies how a JSON that contains the list of features and their states
/// would be parsed.

/// Since the developer has the freedom to choose any data type to represent
/// the states, this is the only class that maps the JSON values into those
/// data types.
abstract class FeatureMapper<S> extends StateNotifier<Map<Feature, S>> {
  FeatureMapper() : super({});

  @override
  void dispose() {
    super.dispose();
  }

  Map<Feature, S> _parseJson(Map<String, dynamic> json) {
    final newStates = <Feature, S>{};

    if (!(json['features'] is List))
      throw StateError('Feature States JSON parse error, not a list');

    final List<dynamic> list = (json['features'] as List);

    list.forEach((feature) {
      final String name = feature['name'];
      final String? version = feature['version'];
      final String state = feature['state'];

      if (name.isNotEmpty && state.isNotEmpty) {
        newStates[Feature(name: name, version: version)] = parseState(state);
      }
    });
    return newStates;
  }

  /// This method creates the interl mapping of states, and the JSON that serves
  /// as the input should have the following structure:
  ///    {
  ///      "features": [
  ///        {"name": "example", "state": "STATE_VALUE"}
  ///      ]
  ///    }
  void load(Map<String, dynamic> json) {
    state = _parseJson(json);
  }

  /// If the initial mapping already exists, this method combines a new JSON
  /// map with the existing one. This is a normal map join, so adding entries
  /// with the same name as existing ones will replace the value
  void append(Map<String, dynamic> json) {
    state = {}
      ..addAll(state)
      ..addAll(_parseJson(json));
  }

  /// This is the method called by other classes in the app, specially the
  /// FeatureWidget, to obtain the current state of any feature in the map
  S getStateFor(Feature feature) => state[feature] ?? defaultState;

  /// This override is required to map correctly between the string
  /// values in the JSON and the state values of the choosen data type
  S parseState(String rawStateName);

  /// This override is used to determine the default value among the possible
  /// states according to the choosen data type. This value will be used
  /// when the parsing process finds string states that don't match to any
  /// possible states, and also while trying to retrieve the state of features
  /// that don't exist in the map or whose name don't match
  S get defaultState;
}
